(unless (boundp '*irtviewer*) (make-irtviewer :draw-origin nil))
(require "package://hrpsys_ros_bridge_tutorials/euslisp/hrp2jsknts-interface.l")
(unless (boundp '*robot*)
  (setq *hrp2jsknts* (instance hrp2jsknts-robot :init)
        *robot* *hrp2jsknts*)
  (objects (list *robot*))
  )

(setq *gnuplot* nil *gp* nil)
;; (load "package://control_tools/estimate-friction.l")

(send *robot* :reset-pose)
(setq hip-y-angle 45)
(send *robot* :lleg :crotch-y :max-angle hip-y-angle)
(send *robot* :lleg :crotch-y :joint-angle hip-y-angle)
(send *robot* :rleg :crotch-y :min-angle (- hip-y-angle))
(send *robot* :rleg :crotch-y :joint-angle (- hip-y-angle))
(send *robot* :fix-leg-to-coords (make-coords))

(send *robot* :legs :move-end-pos #f(-50 0 0))

(send *irtviewer* :change-background #f(1 1 1))
(send *irtviewer* :resize 600 800)

(send *irtviewer* :look1  #f(-50 0 750) 0 10)
;; (send *irtviewer* :look1  #f(-50 -50 0) 45 30)
(if (> (send *irtviewer* :viewer :zoom) 0.5) (send *irtviewer* :viewer :zoom 1.2))
(send *irtviewer* :redraw)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/hip-foot-collision_hrp2_org.png" (unix:getenv "HOME")))
