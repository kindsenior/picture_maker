(unless (boundp '*irtviewer*) (make-irtviewer :draw-origin nil))
(load "package://hrpsys_ros_bridge_tutorials/euslisp/jaxon_blue-interface.l")

(setq *robot* (jaxon_blue))
(objects (list *robot*))

(send-all (send-all (flatten (send-all (send *robot* :links) :get-val 'geometry::bodies)) :glvertices) :set-color #f(0 0 0.5) 0.1)
(mapc #'(lambda (link color) (send (send (car (send link :get-val 'geometry::bodies)) :glvertices) :set-color color 0.5)) (send *robot* :rleg :links) '(#f(1 0 0) #f(0 1 0) #f(0.2 0.2 1) #f(1 0 0) #f(0 1 0) #f(0.2 0.2 1)))

(send *robot* :lleg :angle-vector #f(0 0 0 0 0 0))
(send *robot* :rleg :angle-vector #f(0 0 -50 50 0 0))
(send *robot* :arms :elbow-p :joint-angle 0)

(send *irtviewer* :change-background #f(1 1 1))
(send *irtviewer* :resize 500 700)

(send *irtviewer* :look1  #f(200 -100 550) -60 20)
(if (> (send *irtviewer* :viewer :zoom) 0.5) (send *irtviewer* :viewer :zoom 2.2))
(send *irtviewer* :redraw)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/jaxon3-leg-structure_org.png" (unix:getenv "HOME")))
