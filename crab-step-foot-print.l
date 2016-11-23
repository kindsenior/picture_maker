(unless (boundp '*irtviewer*) (make-irtviewer :draw-origin nil))
(send *irtviewer* :resize 800 800)
(send *irtviewer* :look1 #f(0 100 0) 180 90)
(send *irtviewer* :viewer :viewdistance 4)
(send *irtviewer* :change-background #f(0.6 0.6 0.6))
(send *irtviewer* :draw-objects)

(setq rfoot-vertex-list '(#f(130 75 0) #f(130 -55 0) #f(-100 -55 0) #f(-100 75 0)))

(setq ref-rfoot-pos-list '(#f(0 0 0) #f(0 30 0) #f(0 60 0) #f(0 60 0) #f(0 30 0)))
(setq ref-rfoot-yaw-list '(0 20 -40 40 -20))

(setq act-rfoot-pos-list '(#f(0 0 0) #f(0 25 0) #f(-13 70 0) #f(-10 48 0) #f(0 30 0)))
(setq act-rfoot-yaw-list '(0 24 -46 42 -20))

(defun draw-foot-print (foot-pos-list foot-yaw-list &key (sole-color #f(1 1 1)) (trajectory-color #f(1 0 0)) (width 3))
  (let ( (pos #f(0 0 0)) (yaw 0) )
    (mapc #'(lambda (dpos dyaw)
              (send (make-line pos (v+ pos dpos)) :draw-on :flush t :color trajectory-color :width width)
              (setq pos (v+ pos dpos) yaw (+ yaw dyaw))
              (setq foot-coord (make-coords :pos pos :rpy (list (deg2rad yaw) 0 0)))
              (send foot-coord :draw-on :flush t :size 30)
              (send (instance face :init :vertices (quickhull (mapcar #'(lambda (vertex) (send foot-coord :transform-vector vertex)) rfoot-vertex-list)))
                    :draw-on :flush t :color sole-color :width width)
              )
          foot-pos-list foot-yaw-list)
    ))

(draw-foot-print ref-rfoot-pos-list ref-rfoot-yaw-list :sole-color #f(0 1 0) :trajectory-color #f(0 0.5 0) :width 3)
(draw-foot-print act-rfoot-pos-list act-rfoot-yaw-list :sole-color #f(0 0 1) :trajectory-color #f(0 0 0.5) :width 2)

(send *irtviewer* :viewer :viewsurface :write-to-image-file (format nil "~a/crab-step-foot-print_org.png" (unix:getenv "HOME")))
