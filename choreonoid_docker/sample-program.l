(require :jvrc-standup "package://hrpsys_choreonoid_tutorials/euslisp/action_and_perception/jvrc-statenet.l")

(jaxon_jvrc-init)

;; you should comment out for walking
(send *ri* :stop-impedance :arms)
(send *robot* :reset-pose)
(send *robot* :fix-leg-to-coords (make-coords))
(send *robot* :move-centroid-on-foot :both (list :rleg :lleg))
(send *ri* :angle-vector (send *robot* :angle-vector) 1000)
(send *ri* :stop-st)
(send *ri* :stop-auto-balancer)
;;

(defun your-function ()
  ;; robot is moved to face-up posture
  (reset-position :coords (make-coords
                           :pos (float-vector 0 0 300) ;; (x y z) [mm] position of waist
                           :rpy (list 0 -pi/2 0) ;; (yaw pitch roll) [rad] rotation of waist
                           ))

  (send *robot* :reset-pose)
  ;; the robot in the simulation moves to the same pose as *robot*. it takes base-time [ms].
  (send-pose :real t :base-time 2000)

  (face-up-to-face-down-action)
  )

#|
;;
;; sample of face-up-to-face-down motion
;; this programs is in "package://hrpsys_choreonoid_tutorials/euslisp/action_and_perception/jvrc-standup.l")
;;
(defun face-up-to-face-down-action
  (&key (real nil) (base-time 2500))
  ;; pose 0
  (send *robot* :init-pose)
  (when real
    ;; move to initial pose
    (let ((diff
           (norm (v- (send *robot* :init-pose)
                     (send *ri* :state :potentio-vector)))))
      (setq diff (* diff 25))
      (if (< diff 300) (setq diff 300))
      (send-pose :real real :base-time diff)
      ))

  ;; pose1
  (send *robot* :rarm :collar-y   :joint-angle 80)
  (send *robot* :larm :shoulder-p :joint-angle -90)
  (send *robot* :lleg :crotch-p   :joint-angle -70)
  (send *robot* :lleg :crotch-y   :joint-angle -15)
  (send-pose :real real :base-time base-time) ;; send pose to real robot

  ;; pose 2
  (send *robot* :rleg :knee-p   :joint-angle 90)
  (send *robot* :rleg :crotch-y :joint-angle -49)
  (send *robot* :lleg :knee-p   :joint-angle 90)
  (send-pose :real real :base-time base-time) ;; send pose to real robot

  ;; pose 3
  (send *robot* :rleg :crotch-y :joint-angle 49)
  (send-pose :real real :base-time base-time)

  ;; pose 4
  (send *robot* :larm :shoulder-p :joint-angle -90)
  (send *robot* :rarm :collar-y   :joint-angle 0)
  (send *robot* :lleg :knee-p     :joint-angle 0)
  (send *robot* :rarm :shoulder-p :joint-angle 45)
  (send-pose :real real :base-time base-time)  ;; send pose to real robot

  ;; pose 5
  (send *robot* :init-pose) ;; return to initial pose, the robot is expected to be face-down...
  (send-pose :real real :base-time base-time)
  )
|#
