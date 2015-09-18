(require "package://hrpsys_ros_bridge_tutorials/euslisp/hrp2jsknt-interface.l")

(setq *hrp2jsknt* (instance hrp2jsknt-robot :init))
(objects *hrp2jsknt*)

(send *irtviewer* :resize 600 840)
;; (send *viewer* :viewer :viewsurface :bg-color #f(0.3 0.5 0.2 0))
;; (send *viewer* :viewer :viewsurface :bg-color #f(0.7 0.7 0.7))
(send *irtviewer* :change-background #f(1 1 1))

(send *hrp2jsknt* :fix-leg-to-coords (make-coords))


(send *irtviewer* :viewer :viewing :look  #f(5000 0 1200) #f(0 0 800))
(send *irtviewer* :viewer :viewing :view-angle 0.45)
;; (send *viewer* :viewpoint #f(-3500 7000 2000))

(send *hrp2jsknt* :reset-pose)
(send *hrp2jsknt* :lleg :move-end-pos #f(0 150 100))
(send *hrp2jsknt* :rleg :move-end-pos #f(0 -150 100))
(send *irtviewer* :draw-objects)
(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/move-torso_center_hrp2_org.png" (unix:getenv "HOME")))
;; (read-line)


(send *hrp2jsknt* :reset-pose)
(send *hrp2jsknt* :lleg :move-end-pos #f(0 300 100))
(send *hrp2jsknt* :rleg :move-end-pos #f(0 0 100))
(send *irtviewer* :draw-objects)
(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/move-torso_right_hrp2_org.png" (unix:getenv "HOME")))
;; (read-line)

(send *hrp2jsknt* :reset-pose)
(send *hrp2jsknt* :lleg :move-end-pos #f(0 0 100))
(send *hrp2jsknt* :rleg :move-end-pos #f(0 -300 100))
(send *irtviewer* :draw-objects)
(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/move-torso_left_hrp2_org.png" (unix:getenv "HOME")))

