ball_d = 7;
ball_r = ball_d/2;
ball_tab_len = 1.5;
ball_dist = ball_r + ball_tab_len;

socket_shell_width = 1.5;
socket_r = ball_r + socket_shell_width;
socket_d = 2 * socket_r;

ball_cut_depth = 0.5;
ball_cut_height = -ball_r + ball_cut_depth;
segment_height = 2 * abs(ball_cut_height);
segment_width = 2.5;

segment_cut_height_amt = 0.3;
segment_cut_width_amt = 0.15;
segment_cut_height = segment_height + segment_cut_height_amt;
segment_cut_width = segment_width + segment_cut_width_amt;
segment_d = 1;
