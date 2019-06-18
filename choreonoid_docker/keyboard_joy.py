#!/usr/bin/env python

from __future__ import print_function

import rospy

from sensor_msgs.msg import Joy

import sys, select, termios, tty

msg = """

"""

class JoyPub:
    def __init__(self):
        self.settings_ = termios.tcgetattr(sys.stdin)
        self.pub_ = rospy.Publisher('key_joy', Joy, queue_size = 1)
        self.stop_ = rospy.get_param("~stop", 0.5)

    def main(self):
        prev1 = None
        prev2 = None
        try:
            while(1):
                key = self.getKey()
                if key == '\x03':
                    break
                escaped = False
                if prev2 == '\x1b' and prev1 == '[':
                    escaped = True
                    #print('escaped')
                print('%d %s %s'%(len(key), key.encode('hex'), key))

                prev2 = prev1
                prev1 = key

                msg = Joy()
                msg.axes = [0]*8
                msg.buttons = [0]*11
                if escaped:
                    if key == 'A':
                        msg.axes[1] = -1 ## forward 0.5 m/sec
                    elif key == 'B':
                        msg.axes[1] = 1 ## backward
                    elif key == 'C':
                        msg.axes[0] = 1 ## cw (-yaw) 0.6 rad/sec
                    elif key == 'D':
                        msg.axes[0] = -1 ## ccw(+yaw)
                self.pub_.publish(msg)
        except Exception as e:
            print(e)
        finally:
            msg = Joy()
            msg.axes = [0]*8
            msg.buttons = [0]*11
            self.pub_.publish(msg)
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, self.settings_)

    def getKey(self):
        tty.setraw(sys.stdin.fileno())
        keys = []
        key = None
        while(True):
            ret = select.select([sys.stdin], [], [], 0)
            ##print(ret)
            # if len(ret[0]) < 1:
            #     if len(keys) >= 1:
            #         break
            #     msg = Joy()
            #     msg.axes = [0]*8
            #     msg.buttons = [0]*11
            #     self.pub_.publish(msg)
            #     continue
            key = sys.stdin.read(1)
            keys.append(key)
            if len(key) >= 1:
                break

        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, self.settings_)
        #print(keys)
        #''.join(keys)
        return key

def vels(speed,turn):
    return "currently:\tspeed %s\tturn %s " % (speed,turn)

if __name__=="__main__":
    rospy.init_node('keyboard_joy')

    jp = JoyPub()

    jp.main()

