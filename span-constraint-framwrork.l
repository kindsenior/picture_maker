(load "contact-constraint-framework.l")

(defun draw-span-constraint-framework (&key (force-vec) (moment-vec) (cur-pos #f(0 0 0)) (cur-rot (unit-matrix)) (v-dt #f(0 0 0)) (w-dt #f(0 0 0)) (mu 0.5) (grid '(1 1)) (flush nil)
                                            (vertex-list '(#f(0.5 0 0) #f(-0.5 0 0) #f(0 0.01 0) #f(0 -0.01 0))) (unilateral t))
  (let ((color-list '(#f(1 0 0) #f(0 1 0) #f(0 0 1))) )

    (setq vertex-list (send (send *robot* :support-polygon *support-leg*) :vertices))

    (send *irtviewer* :viewer :viewsurface :line-width 4)

    (dolist (force-point vertex-list)
      ;; draw force
      (dotimes (i 3)
        (send *viewer* :draw-arrow force-point (v+ force-point (scale (elt (send (make-coords :rot cur-rot) :inverse-transform-vector force-vec) i) (matrix-column cur-rot i))) :color (elt color-list i))
        )
      )

    (when flush
      (send *viewer* :flush)
      (send *viewer* :draw-objects :flush nil))

    ))

(draw-span-constraint-framework :force-vec #f(50 50 50) :moment-vec #f(-15 5 45)
           :cur-pos (send *robot* *support-leg* :end-coords :worldpos) :cur-rot (send *robot* *support-leg* :end-coords :worldrot)
           :v-dt #f(5 5 0) :w-dt #f(0 0 0.1) :mu 0 :grid '(3 3) :flush t
           :vertex-list vertex-list)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/span-constraint-framework_org.png" (unix:getenv "HOME")))
