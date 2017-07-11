
(ros::roseus "tf_test")

(setq *tfl* (instance ros::transform-listener :init))

(unix::usleep (* 2 1000 1000))
(warn "~%;; start checking TF~%")
(let (ret tm)
  (while t
    (setq tm (ros::time-now))
    (setq ret (send *tfl* :wait-for-transform "BODY" "left_camera_optical_frame" tm 2))
    (unless ret (warn ";; fail at ~A~%" tm))
    (when ret
      (warn ";; success at ~A~%" tm)
      (exit)
      )
    )
  )
