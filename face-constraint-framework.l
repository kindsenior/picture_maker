(load "contact-constraint-framework.l")

(defun draw-face-constraint-framework (&key (force-vec) (moment-vec) (cur-pos #f(0 0 0)) (cur-rot (unit-matrix)) (v-dt #f(0 0 0)) (w-dt #f(0 0 0)) (mu 0.5) (grid '(1 1)) (flush nil)
                                            (vertex-list '(#f(0.5 0 0) #f(-0.5 0 0) #f(0 0.01 0) #f(0 -0.01 0))) (unilateral t))
  (let ((color-list '(#f(1 0 0) #f(0 1 0) #f(0 0 1))) )

    (send *irtviewer* :viewer :viewsurface :line-width 4)

    ;; draw force
    (dotimes (i 3)
      (send *viewer* :draw-arrow cur-pos (v+ cur-pos (scale (elt (send (make-coords :rot cur-rot) :inverse-transform-vector force-vec) i) (matrix-column cur-rot i))) :color (elt color-list i))
      )

    ;; draw moment
    (dotimes (i 3)
      (send *viewer* :viewsurface :color (elt color-list i))
      ;; (send *viewer* :draw-circle (make-coords :pos cur-pos) :radius 30 :arrow nil :arc 0 :flush nil)
      (send *viewer* :draw-circle (make-coords :pos cur-pos :rpy (scale (deg2rad 90) (elt color-list (mod (1+ i) 3))) :radius (elt moment-vec i) :flush nil))
      )

    (when flush
      (send *viewer* :flush)
      (send *viewer* :draw-objects :flush nil))

    ))

(draw-face-constraint-framework :force-vec #f(200 150 200) :moment-vec #f(-30 5 60)
           :cur-pos (send *robot* *support-leg* :end-coords :worldpos) :cur-rot (send *robot* *support-leg* :end-coords :worldrot)
           :v-dt #f(5 5 0) :w-dt #f(0 0 0.1) :mu 0 :grid '(3 3) :flush t
           :vertex-list vertex-list)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/face-constraint-framework_org.png" (unix:getenv "HOME")))
