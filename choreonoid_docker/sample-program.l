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
  )

#| ;; sample of face-up-to-face-down motion

|#
