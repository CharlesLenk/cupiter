ball_d = 7;
ball_r = ball_d/2;
ball_tab_len = 1.5;
ball_dist = ball_r + ball_tab_len;

socket_shell_width = 1.5;
socket_r = ball_r + socket_shell_width;
socket_d = 2 * socket_r;
socket_dist = socket_d/2;

ball_cut_depth = 0.5;
ball_cut_height = -ball_r + ball_cut_depth;
segment_height = 2 * abs(ball_cut_height);
segment_width = 2.5;

segment_cut_height_amt = 0.3;
segment_cut_width_amt = 0.15;
segment_cut_height = segment_height + segment_cut_height_amt;
segment_cut_width = segment_width + segment_cut_width_amt;
segment_d = 1;

shoulder_armor_tab_width = 1.3;
rotator_peg_l = 8 + shoulder_armor_tab_width;
rotator_peg_d = 0.95 * ball_d;
rotator_socket_l = rotator_peg_l + socket_shell_width - shoulder_armor_tab_width;
rotator_socket_d = rotator_peg_d + 2 * socket_shell_width;

armor_height = segment_height + 3;

hip_width = 6.5 + 2 * ball_dist;
shoulder_width = 2 * hip_width;
shoulder_height = 4;
body_len = 35 + shoulder_height;

snap_depth = 0.3;

elbow_wall_width = 1.5;
elbow_peg_d = 4.5;
elbow_peg_h = segment_height - elbow_wall_width;
elbow_socket_d = elbow_peg_d + 3;
elbow_peg_size = elbow_socket_d + 2.7;
elbow_peg_len = elbow_peg_size/2;
elbow_socket_len = elbow_socket_d/2;

elbow_joint_offset = -2;
knee_joint_offset = -2.3;
elbow_max_angle = 160;
knee_max_angle = 165;

waist_socket_gap = -0.2;

arm_armor_y_offset = 1;
leg_armor_y_offset = 1;

BALL = 1;
SOCKET = 2;
ELBOW_PEG = 3;
ELBOW_SOCKET = 4;
KNEE_PEG = 5;
KNEE_SOCKET = 6;
ROTATOR_SOCKET = 7;
ROTATOR_PEG = 8;
WAIST_SOCKET = 9;
SHOULDER_SOCKET = 10;
HIP_SOCKET = 11;

armature_color = "#464646";
armor_color = "#DDDDDD";
