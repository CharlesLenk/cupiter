include <globals.scad>

rotator_peg_l = 8;
rotator_peg_d = segment_height + 0.3;
rotator_socket_l = rotator_peg_l + socket_shell_width;
rotator_socket_d = rotator_peg_d + 2 * socket_shell_width;

hinge_armor_y_offset = 1;
hinge_peg_d = 4;
hinge_socket_d = hinge_peg_d + 3;

arm_upper_len = 22;
arm_lower_len = 0.9 * arm_upper_len;
elbow_joint_offset = -2;

arm_armor_upper_len = arm_upper_len - ball_dist;
arm_armor_lower_len = arm_lower_len - ball_dist;

hip_armor_tab_width = 1.3;
leg_len = 33;
leg_upper_len = leg_len - socket_d/2 - hip_armor_tab_width;
knee_joint_offset = -2.3;
