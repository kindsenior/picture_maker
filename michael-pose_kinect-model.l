(require "package://roseus_tutorials/src/kinect-model-viewer.l")

(if (not (boundp '*model*)) (setq *model* (make-kinect-bvh-robot-model)))

(objects *model*)
(send *irtviewer* :change-background #f(1 1 1))

(send *irtviewer* :viewer :viewing :look  #f(2000 4000 0) #f(0 0 0))

(send *model* :angle-vector #f(0 0 0 0 70 20     10 40 0  0 -80 0   0 70 0   0 -10 0      20 0 0  0 -20 -20    0 0 -10   0 120 20  0 -20 0))
(send *irtviewer* :draw-objects)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/michael-pose_kinect-model.png" (unix:getenv "HOME")))
