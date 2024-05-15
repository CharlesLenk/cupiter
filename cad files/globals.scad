ball_r = 3.5;
ball_d = 2 * ball_r;
ball_tab_len = 1.4;
ball_dist = ball_r + ball_tab_len;

socket_shell_width = 1.5;
socket_r = ball_r + socket_shell_width;
socket_d = 2 * socket_r;

ball_cut_depth = 0.5;
ball_cut_height = -ball_r + ball_cut_depth;
segment_height = 2 * (ball_r - ball_cut_depth);
segment_width = 2.5;

segment_cut_height_offset = 0.3;
segment_cut_width_offset = 0.15;
segment_cut_height = segment_height + segment_cut_height_offset;
segment_cut_width = segment_width + segment_cut_width_offset;

edge_d = 1;

min_wall_width = 1.2;

frame_color = "#A0CFEC";
armor_color = "#E0E5E5";

// Body Proportions
hip_width = 6 + 2 * ball_dist;
shoulder_width = 27.5;
shoulder_height = 7;
torso_len = 36 + shoulder_height;
neck_len = 7.5;

arm_upper_len = 21;
arm_lower_len = 0.9 * arm_upper_len;

leg_lower_len = 33;
hip_armor_tab_width = 1.2;
hip_peg_extension = hip_armor_tab_width + 0.25;
leg_upper_len = leg_lower_len - socket_d/2 - hip_peg_extension;

// Joint Tolerances
head_and_foot_tolerance = -0.15;
upper_chest_tolerance = -0.05;
waist_tolerance = -0.2;

hip_shoulder_tolerance = -0.15;
elbow_knee_tolerance = -0.05;
leg_rotator_tolerance = 0.15;

hand_advanced_tolerance = -0.2;
hand_simple_tolerance = -0.1;
