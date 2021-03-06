(load "contact-constraint-framework.l")

(defun draw-dfcc (&key (force-vec) (moment-vec) (cur-pos #f(0 0 0)) (cur-rot (unit-matrix)) (v-dt #f(0 0 0)) (w-dt #f(0 0 0)) (mu 0.5) (grid '(1 1)) (flush nil)
                                 (vertex-list '(#f(0.5 0 0) #f(-0.5 0 0) #f(0 0.01 0) #f(0 -0.01 0))) (unilateral t))
  (let ((color-list '(#f(1 0 0) #f(0 1 0) #f(0 0 1))) (distributed-fz-vec) (point-num))

    (send *irtviewer* :viewer :viewsurface :line-width 4)
    (multiple-value-setq (A B force-point-list dxy-list) (get-convert-matrix cur-pos cur-rot v-dt w-dt mu :draw t :size 3 :grid grid :vertex-list vertex-list));; [m]
    (setq point-num (length (matrix-row A 0)))

    (setq distributed-fz-vec (solve-qpoases-qp ;; with inequality constraints
                                  :eval-weight-matrix (unit-matrix point-num)
                                  :eval-coeff-vector (make-array point-num :element-type float-vector :initial-element 0)
                                  :inequality-matrix (unit-matrix point-num)
                                  :inequality-min-vector (make-array point-num :element-type float-vector :initial-element 0)
                                  :equality-matrix A
                                  :equality-vector (float-vector (elt force-vec 2) (elt moment-vec 0) (elt moment-vec 1))))

    (when distributed-fz-vec
      ;; draw foot
      (send (instance face :init :vertices (quickhull force-point-list)) :draw-on :flush nil :color #f(0 0 1))

      ;; draw distributed force
      (mapc #'(lambda (force-point fz dxy)
                (send *viewer* :draw-arrow force-point (v+ force-point (concatenate float-vector (scale 1 dxy) #f(0))) :color #f(0.5 0.5 1))
                (send *viewer* :draw-arrow force-point (v+ force-point (concatenate float-vector (scale (* mu fz -1) dxy) (float-vector fz))) :color #f(1 0.8 0)))
            force-point-list (coerce distributed-fz-vec cons) dxy-list)

      ;; draw force
      (dotimes (i 2)
        ;; (send *viewer* :draw-arrow cur-pos (v+ cur-pos (scale (elt moment-vec i) (matrix-column cur-rot i))))
        ;; (send *viewer* :draw-arrow cur-pos (v+ cur-pos (scale (* 10 (elt (send (make-coords :rot cur-rot) :inverse-transform-vector moment-vec) i)) (matrix-column cur-rot i))) :color (elt color-list i))
        (send *viewer* :draw-arrow cur-pos (v+ cur-pos (scale (elt (send (make-coords :rot cur-rot) :inverse-transform-vector force-vec) i) (matrix-column cur-rot i))) :color (elt color-list i))
        )

      ;; draw moment
      (send *viewer* :viewsurface :color #f(0 0 1))
      ;; (send *viewer* :draw-circle (make-coords :pos cur-pos) :radius 30 :arrow nil :arc 0 :flush nil)
      (send *viewer* :draw-circle (make-coords :pos cur-pos) :radius (elt moment-vec 2) :flush nil)

      )

    (when flush
      (send *viewer* :flush)
      (send *viewer* :draw-objects :flush nil))

    (list A B distributed-fz-vec)
    ))

(defun draw-dfcc-animation ()
  (let ((i 0) (dt 0.01) (cycle 1))
    (do-until-key
     (draw-dfcc :force-vec #f(200 100 1000) :moment-vec (float-vector (* -15 (sin (* 2 pi (/ (* i dt) cycle)))) (* 15 (sin (* 2 pi (/ (* i dt) cycle)))) 45)
                :cur-pos (send *robot* *support-leg* :end-coords :worldpos) :cur-rot (send *robot* *support-leg* :end-coords :worldrot)
                :v-dt #f(5 5 0) :w-dt (float-vector 0 0 (* 0.1 (+ 1 (sin (* 2 pi (/ (* i dt) cycle)))))) :mu 0 :grid '(3 3) :flush t
                :vertex-list vertex-list)
     (unix:usleep (round (* dt 1000000)))
     (incf i)
     )
    )
  )

(draw-dfcc :force-vec #f(200 100 1000) :moment-vec #f(-15 15 45)
           :cur-pos (send *robot* *support-leg* :end-coords :worldpos) :cur-rot (send *robot* *support-leg* :end-coords :worldrot)
           :v-dt #f(5 5 0) :w-dt #f(0 0 0.1) :mu 0 :grid '(3 3) :flush t
           :vertex-list vertex-list)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/distributed-foot-force-constraint-framework_org.png" (unix:getenv "HOME")))
