
# Choreonoid Examples

## Downlowd image for choreonoid

For Nvidia users

~~~
docker pull yoheikakiuchi/choreonoid:16.04_latest_ros
## use ./run_choreonoid.sh
~~~

For NOT Nvidia users (not using OpenGL)

~~~
docker pull yoheikakiuchi/choreonoid:16.04_no_gl_latest_ros
## use ./run_no_gl_choreonoid.sh
~~~

## Run Choreonoid
In the directory, "robotsimulation-docker/choreonoid-docker"

Nvidia
~~~
./run_choreonoid.sh
~~~

NOT Nvidia
~~~
./run_no_gl_choreonoid.sh
~~~

# Choreography Sample

https://choreonoid.org/ja/tutorials.html


- File -> Open Project -> SR1Minimum.cnoid (Samplerobot minimumを選択)
- (select SR1)
- File -> New -> PoseSeq
- View -> Show View -> Pose Roll
- (select PoseSeq)
- on 'Pose Roll' view
  - Insert
  - Update

# WRS2018 (ROS sample)

https://choreonoid.org/ja/manuals/latest/wrs2018/index.html

In the directory, "robotsimulation-docker/choreonoid-docker"

~~~
(terminal 1)
$ ./run_choreonoid roscore

(terminal 2)
$ DOCKER_OPTION=-it ./exec_choreonoid.sh bash
$ choreonoid /choreonoid_ws/devel/share/choreonoid-1.7/WRS2018/script/T1M-AizuSpiderSS-ROS.py

(terminal 3)
$ ./exec_choreonoid.sh /my_entrypoint.sh rosrun choreonoid_joy node
Ros core running on host OS
~~~

OR

~~~
(terminal 1)
$ roscore ###　ノートパソコンなど

(terminal 2)
$ DOCKER_OPTION=-it ./run_choreonoid.sh bash
$ choreonoid /choreonoid_ws/devel/share/choreonoid-1.7/WRS2018/script/T1M-AizuSpiderSS-ROS.py

(terminal 3)
$ ./exec_choreonoid.sh /my_entrypoint.sh rosrun choreonoid_joy node
~~~


# Using simulation with ROS

## Install docker and nvidia-docker
https://github.com/YoheiKakiuchi/robotsimulation-docker/blob/master/README.md

### Downlowd image for simulation
~~~
docker pull yoheikakiuchi/choreonoidsim:16.04_release-1.6
~~~

### Run simulation
~~~
$ ./run.sh
## this equals to './run.sh rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch'
~~~

### If you do not have NVIDIA graphic card
~~~
$ DOCKER=docker ./run.sh
## add DOCKER=docker to ./exec.sh
~~~

### Run perception nodes
~~~
$ ./exec.sh '/my_entrypoint.sh roslaunch hrpsys_choreonoid_tutorials tracking_recognition.launch gui:=true'
~~~

### Run robot moving nodes  (run with perception nodes)
~~~
$ ./exec.sh '/my_entrypoint.sh roseus /catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/euslisp/action_and_perception/walk-to-target.l (progn (make-random-first-position) (walk-to-target))'
~~~

### Run robot getting up (StateNet)
~~~
$ ./exec.sh '/my_entrypoint.sh roseus /catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/euslisp/action_and_perception/jvrc-statenet.l (start-statenet-demo)'
~~~

### Run robot kicking ball (run with perception nodes)
video: https://www.youtube.com/watch?v=tCI5L__FYic
~~~
$ ./exec.sh '/my_entrypoint.sh roseus /catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/euslisp/action_and_perception/kick-ball-demo.l (kick-ball-to-goal-demo)'
~~~

### Run rviz (visualizer of ROS)
~~~
$ ./exec.sh '/my_entrypoint.sh rosrun rviz rviz -d /catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/config/jaxon_jvrc.rviz'
~~~

### Runnig your programs 
* easy version
~~~
$ ./run.sh
$ ./exec.sh '/my_entrypoint.sh roseus /userdir/sample-program.l (your-function)'
## you can write program with robotsimulation-docker/chorenoid_docker/sample-program.l
~~~

* advanced version
~~~
$ ./run.sh
$ ./exec.sh
docker$ . /catkin_ws/devel/setup.bash
docker$ roscd hrpsys_choreonoid_tutorials
docker$ roseus euslisp/jaxon_jvrc-interface.l
docker$ roseus$ jaxon_jvrc-init
;; *ri* and *jaxon_jvrc* created
~~~

http://wiki.ros.org/rtmros_common/Tutorials/WorkingWithEusLisp

### Programming Robot with Lisp

https://github.com/euslisp/jskeus/blob/master/doc/jmanual.pdf
第III部 irteus拡張を参照

### Loading robot model and interface
~~~
(load "package://hrpsys_choreonoid_tutorials/euslisp/jaxon_jvrc-interface.l")

(jaxon_jvrc-init) ;; with simulation
(jaxon_jvrc) ;; without simulation
~~~

### Visualize robot
~~~
(setq *robot* *jaxon_jvrc*)

;; visualize robot
(objects (list *robot*))
~~~

### Set poses
~~~
;; pre defined poses
(send *robot* :reset-pose)
(send *robot* :reset-manip-pose)
~~~

### Access to joints
~~~
;; angle-vector (vector of each joint angle)
(send *robot* :angle-vector)

;; angle-vector of each limb
(send *robot* :rarm  :anlge-vector)
(send *robot* :rleg  :anlge-vector)
(send *robot* :head  :anlge-vector)
(send *robot* :torso :anlge-vector)

;; list of joint
(send *robot* :joint-list)
~~~

### Access to joints (by name)
~~~
;;;; all joints (access by joint name)
;; head
(send *robot* :head :neck-p :joint-angle)
(send *robot* :head :neck-y :joint-angle)

;; arm (:rarm :larm)
(send *robot* :rarm :collar-y :joint-angle)
(send *robot* :rarm :shoulder-p :joint-angle)
(send *robot* :rarm :shoulder-r :joint-angle)
(send *robot* :rarm :shoulder-y :joint-angle)
(send *robot* :rarm :elbow-p :joint-angle)
(send *robot* :rarm :wrist-y :joint-angle)
(send *robot* :rarm :wrist-r :joint-angle)
(send *robot* :rarm :wrist-p :joint-angle)

;; torso
(send *robot* :torso :waist-p :joint-angle)
(send *robot* :torso :waist-r :joint-angle)
(send *robot* :torso :waist-y :joint-angle)

;; leg (:rleg :lleg)
(send *robot* :rleg :crotch-y :joint-angle)
(send *robot* :rleg :crotch-r :joint-angle)
(send *robot* :rleg :crotch-p :joint-angle)
(send *robot* :rleg :knee-p :joint-angle)
(send *robot* :rleg :ankle-p :joint-angle)
(send *robot* :rleg :ankle-r :joint-angle)

;; search position of joint
(position (send *robot* :rleg :ankle-r) (send *robot* :joint-list) )
~~~

### Move robot coordinates
~~~
;; move robot(root)
(send *robot* :fix-leg-to-coords (make-coords))
~~~

### Move end-coords of limbs
~~~
;; move limbs
(send *robot* :larm :move-end-pos (float-vector 0 0 70) :world)

;; inverse-kinematics
(send *robot* :rarm :end-coords :draw-on :flush t :width 2 :size 200)
(let ((cds (send *robot* :rarm :end-coords :copy-worldcoords)))
  (send cds :translate (float-vector 0 0 70) :world)
  (send cds :draw-on :flush t :width 2 :size 200 :color (float-vector 1 1 0))
  (send *robot* :rarm :inverse-kinematics cds)
  )
(send *irtviewer* :draw-objects)
~~~

### Move actual robot
~~~
;; move actual robot
(send *ri* :angle-vector (send *robot* :angle-vector) 3000) ;; angle-vector time [ms]
(send *ri* :wait-interpolation) ;; wait until finishing
~~~

### Walking
~~~
;; walk
(send *ri* :go-pos 1.0 0 0) ;; x y theta

;; walk
(send *ri* :go-velocity 0 0 0) ;; x_vel y_vel theta_vel
(send *ri* :go-stop)
~~~
