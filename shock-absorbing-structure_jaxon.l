(require "package://hrpsys_ros_bridge_tutorials/euslisp/jaxon-interface.l")

(unless (boundp '*jaxon*) (setq *jaxon* (instance jaxon-robot :init)))

;; (objects *jaxon*)
(make-irtviewer)
(setq link-lists (remove (send *jaxon* :chest_link2_lk) (send *jaxon* :links)))
(mapc #'(lambda (link) (setq link-lists (remove link link-lists))) (send *jaxon* :rarm))
(objects link-lists)
(send *irtviewer* :resize 700 1400)

(send *irtviewer* :change-background #f(1 1 1))
;; (send *irtviewer* :viewer :viewing :look  (float-vector (+ -2250 100) 4400 2500) (float-vector 100 0 1000))
(send *irtviewer* :viewer :viewing :look  (float-vector (+ -2000 0) 4000 3000) (float-vector 0 0 1000))

(send *jaxon* :arms :shoulder-p :joint-angle 20)
(send *jaxon* :arms :elbow-p :joint-angle -20)
(send *jaxon* :larm :collar-y :joint-angle -20)
(send *jaxon* :rarm :collar-y :joint-angle 20)

(send *irtviewer* :draw-objects)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/jaxon_shock-absoribng-structure_whole-body_org.png" (unix:getenv "HOME")))
