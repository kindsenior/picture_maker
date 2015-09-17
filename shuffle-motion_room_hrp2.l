(unless (boundp '*pickview*) (setq *pickview* (pickview :no-menu t)))
(send *pickview* :resize 600 840)
(send *pickview* :viewer :viewsurface :bg-color #f(0.8 0.65 0.5))
;; (send *pickview* :white-back t)

(unless (boundp '*hrp2jsknts*) (setup-model-for-hrp2))

(setq *drawer* (make-unknown-wooden-drawers))
(send *drawer* :newcoords (make-coords :pos #f(-1000 -500 0) :rpy (float-vector (deg2rad 90) 0 0)))

(setq *fridge* (make-hitachi-fiesta-refrigerator))
(send *fridge* :newcoords (make-coords :pos #f(-300 -500 0) :rpy (float-vector (deg2rad 90) 0 0)))

(setq *chair* (instance chair :init))
(send *chair* :newcoords (make-coords :pos #f(-800 100 0) :rpy (float-vector (deg2rad 160) 0 0)))

(setq *desk* (instance x-leg-desk :init))
(send *desk* :newcoords (make-coords :pos #f(-800 800 350) :rpy (float-vector (deg2rad 90) 0 0)))

(setq *floor* (make-cube 3000 5000 1))
(send *floor* :set-color :brown)
(send *floor* :locate #f(-500 -1000 0) :world)

(setq *box* (make-cube 500 400 300))
(send *box* :set-color #f(0.7 0.5 0.3))
(send *box* :newcoords (make-coords :pos #f(-650 600 1000)))

(objects (list *hrp2jsknts* *floor* *drawer* *fridge* *chair* *desk* *box*))
(send *pickview* :change-zoom 2.5)
(send *pickview* :viewangle #f(8800.0 30.0 7.0))
(send *pickview* :move-view-target #f(-100 700 800))
;; (send *pickview* :viewpoint #f(-3500 7000 2000))

(send *hrp2jsknts* :reset-pose)
(send *hrp2jsknts* :legs :crotch-p :joint-angle 5)
(send *hrp2jsknts* :torso :waist-p :joint-angle 20)
(send *hrp2jsknts* :arms :shoulder-r :joint-angle -10)
(send *hrp2jsknts* :arms :shoulder-p :joint-angle -10)
(send *hrp2jsknts* :arms :elbow-p :joint-angle -50)
(send *hrp2jsknts* :arms :wrist-p :joint-angle -30)
(send *hrp2jsknts* :lleg :move-end-pos #f(200 100 50))
(send *hrp2jsknts* :rleg :move-end-pos #f(-100 -100 50))
;; (send *hrp2jsknts* :arms :move-end-pos #f(-150 0 150) :local)
;; (send *hrp2jsknts* :larm :wrist-p :joint-angle 0)
;; (send *hrp2jsknts* :rarm :wrist-p :joint-angle 0)
(send *hrp2jsknts* :fix-leg-to-coords (make-coords :pos #f(-650 450 0) :rpy (float-vector (deg2rad 90) 0 0)))
;; (send *hrp2jsknts* :head :neck-p :joint-angle 30)


(defun draw-on-convex ()
  (send (instance face :init :vertices (quickhull (flatten (send-all (mapcar #'(lambda (i faces) (elt faces i)) '(7 1 1 1) (reduce #'(lambda (ret limb) (car (last (mapcar #'(lambda (val) (push-back val ret)) (mapcar #'(lambda (idx) (send (elt (send *hrp2jsknts* limb :links) idx) :faces)) '(5 6))))) ) '(nil :lleg :rleg))) :vertices)))) :draw-on :flush t :width 3 :color #f(0 1 0)))

(defun save ()
  (send *pickview* :viewer :viewsurface :write-to-jpg-file "shuffle-motion_room_hrp2_org.jpg"))

