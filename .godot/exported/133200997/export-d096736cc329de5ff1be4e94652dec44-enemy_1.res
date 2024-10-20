RSRC                    VisualShader            ��������                                            3      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports 	   constant    script    op_type 	   operator    input_name    code    graph_offset    mode    flags/collision_use_scale    flags/disable_force    flags/disable_velocity    flags/keep_data    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/2/node    nodes/start/2/position    nodes/start/4/node    nodes/start/4/position    nodes/start/5/node    nodes/start/5/position    nodes/start/6/node    nodes/start/6/position    nodes/start/7/node    nodes/start/7/position    nodes/start/8/node    nodes/start/8/position    nodes/start/9/node    nodes/start/9/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        +   local://VisualShaderNodeVec2Constant_3jmcb       +   local://VisualShaderNodeVec2Constant_dwwlu A      *   local://VisualShaderNodeRandomRange_mado4 ~      '   local://VisualShaderNodeVectorOp_2vt31 �      ,   local://VisualShaderNodeVectorCompose_iwip6 W      $   local://VisualShaderNodeInput_h5nsc �      ,   local://VisualShaderNodeVectorCompose_jo5dj �         local://VisualShader_tettv B	         VisualShaderNodeVec2Constant       
         �?         VisualShaderNodeVec2Constant       
      @  �@         VisualShaderNodeRandomRange                         �?  �?  �?            �            @         VisualShaderNodeVectorOp                    
                 
                              VisualShaderNodeVectorCompose                       VisualShaderNodeInput    	         time          VisualShaderNodeVectorCompose                                                                           VisualShader    
      �  shader_type particles;


float __rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

float __rand_from_seed_m1_p1(inout uint seed) {
	return __rand_from_seed(seed) * 2.0 - 1.0;
}

float __randf_range(inout uint seed, float from, float to) {
	return __rand_from_seed(seed) * (to - from) + from;
}

uint __hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

mat3 __build_rotation_mat3(vec3 axis, float angle) {
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat3(vec3(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s), vec3(oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s), vec3(oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c));
}

mat4 __build_rotation_mat4(vec3 axis, float angle) {
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(vec4(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0), vec4(oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, 0), vec4(oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c, 0), vec4(0, 0, 0, 1));
}

vec2 __get_random_unit_vec2(inout uint seed) {
	return normalize(vec2(__rand_from_seed_m1_p1(seed), __rand_from_seed_m1_p1(seed)));
}

vec3 __get_random_unit_vec3(inout uint seed) {
	return normalize(vec3(__rand_from_seed_m1_p1(seed), __rand_from_seed_m1_p1(seed), __rand_from_seed_m1_p1(seed)));
}



// 3D Noise with friendly permission by Inigo Quilez
vec3 hash_noise_range( vec3 p ) {
	p *= mat3(vec3(127.1, 311.7, -53.7), vec3(269.5, 183.3, 77.1), vec3(-301.7, 27.3, 215.3));
	return 2.0 * fract(fract(p)*4375.55) -1.;
}

void start() {
	uint __seed = __hash(NUMBER + uint(1) + RANDOM_SEED);

	{
// Vector2Constant:2
		vec2 n_out2p0 = vec2(0.000000, 1.000000);


// VectorCompose:9
		float n_in9p0 = 0.00000;
		float n_in9p1 = 0.00000;
		float n_in9p2 = 0.00000;
		vec3 n_out9p0 = vec3(n_in9p0, n_in9p1, n_in9p2);


// Vector2Constant:4
		vec2 n_out4p0 = vec2(2.000000, 7.000000);


// Input:8
		float n_out8p0 = TIME;


// RandomRange:5
		float n_in5p1 = -2.00000;
		float n_in5p2 = 2.00000;
		float n_out5p0 = mix(n_in5p1, n_in5p2, hash_noise_range(vec3(n_out8p0)).x);


// VectorCompose:7
		float n_in7p1 = 0.00000;
		vec2 n_out7p0 = vec2(n_out5p0, n_in7p1);


// VectorOp:6
		vec2 n_out6p0 = n_out4p0 + n_out7p0;


// StartOutput:0
		VELOCITY = vec3(n_out2p0, 0.0);
		COLOR.rgb = n_out9p0;
		if (RESTART_POSITION) {
			TRANSFORM = mat4(vec4(1.0, 0.0, 0.0, 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(vec3(n_out6p0, 0.0), 1.0));
			if (RESTART_VELOCITY) {
				VELOCITY = (EMISSION_TRANSFORM * vec4(VELOCITY, 0.0)).xyz;
			}
			TRANSFORM = EMISSION_TRANSFORM * TRANSFORM;
		}


	}
}

                                                                  
     ��  C               
     ��  pC               
     ��  �C               
     �B  �C             !   
   �!��3c�C"            #   
   9Ě��C$            %   
     HC    &                                                                                             	                    RSRC