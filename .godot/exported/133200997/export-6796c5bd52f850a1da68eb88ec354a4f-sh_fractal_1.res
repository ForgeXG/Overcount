RSRC                    VisualShader            ��������                                            E      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    op_type 	   operator 	   constant    size    expression    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/20/size    nodes/fragment/20/input_ports    nodes/fragment/20/output_ports    nodes/fragment/20/expression    nodes/fragment/22/node    nodes/fragment/22/position    nodes/fragment/23/node    nodes/fragment/23/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_xippk 
      $   local://VisualShaderNodeInput_x0hbk L
      '   local://VisualShaderNodeVectorOp_t1a5d �
      '   local://VisualShaderNodeVectorOp_k77rp �
      '   local://VisualShaderNodeVectorOp_mg7v8 n      '   local://VisualShaderNodeVectorOp_rwrm0 �      $   local://VisualShaderNodeInput_qdla7 X      $   local://VisualShaderNodeInput_ae1nj �      ,   local://VisualShaderNodeFloatConstant_bxe31 �      )   local://VisualShaderNodeExpression_r74if       '   local://VisualShaderNodeVectorOp_bvbnn �      ,   local://VisualShaderNodeFloatConstant_3camd 9          res://shaders/sh_fractal_1.tres s         VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                                  VisualShaderNodeVectorOp                                            ���=���=���=	                  VisualShaderNodeVectorOp                    
                 
     �A  A          	                  VisualShaderNodeVectorOp                    
                 
     �C  �C          	                  VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeInput             time          VisualShaderNodeFloatConstant    
      ��L=         VisualShaderNodeExpression       
   ��oD�D      |  vec2 z = vec2(cos(t) * 0.1, sin(t) * 0.1);
int br = 0;
for (int i = 0; i < int(l); ++i) {
	++br;
	z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + v;
	// z = vec2(pow(z.x, 4.0) - 6.0 * pow(z.x * z.y, 2.0) + pow(z.y, 4.0),
	// 4.0 * (z.x * z.x * z.x * z.y - z.y * z.y * z.y * z.x)) + v;
	if (sqrt(pow(z.x, 3.0) + pow(z.y, 3.0)) > 2.0) {
		break;
	}
};
res = float(br) / l * 2.0;          VisualShaderNodeVectorOp                    
                 
   ���   �                   VisualShaderNodeFloatConstant    
        �B         VisualShader "           shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:3
	vec4 n_out3p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// VectorOp:22
	vec2 n_in22p1 = vec2(-0.60000, -0.50000);
	vec2 n_out22p0 = n_out2p0 + n_in22p1;


// Input:12
	vec2 n_out12p0 = SCREEN_PIXEL_SIZE;


// VectorOp:11
	vec2 n_in11p1 = vec2(300.00000, 300.00000);
	vec2 n_out11p0 = n_out12p0 * n_in11p1;


// VectorOp:10
	vec2 n_out10p0 = n_out22p0 / n_out11p0;


// Input:15
	float n_out15p0 = TIME;


// FloatConstant:23
	float n_out23p0 = 100.000000;


	float n_out20p0;
// Expression:20
	n_out20p0 = 0.0;
	{
		vec2 z = vec2(cos(n_out15p0) * 0.1, sin(n_out15p0) * 0.1);
		int br = 0;
		for (int i = 0; i < int(n_out23p0); ++i) {
			++br;
			z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + n_out10p0;
			// z = vec2(pow(z.x, 4.0) - 6.0 * pow(z.x * z.y, 2.0) + pow(z.y, 4.0),
			// 4.0 * (z.x * z.x * z.x * z.y - z.y * z.y * z.y * z.x)) + n_out10p0;
			if (sqrt(pow(z.x, 3.0) + pow(z.y, 3.0)) > 2.0) {
				break;
			}
		};
		n_out20p0 = float(br) / n_out23p0 * 2.0;
	}


// FloatConstant:19
	float n_out19p0 = 0.050000;


// VectorOp:5
	vec3 n_out5p0 = vec3(n_out20p0) * vec3(n_out19p0);


// VectorOp:4
	vec4 n_out4p0 = n_out3p0 + vec4(n_out5p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out4p0.xyz);


}
                       
    ��D  �B                
     C�  �B               
     ��  ��               
    ��D  �B               
    ��D  HC             !   
     ��  4C"            #   
     ��  pC$            %   
     >�  pC&            '   
     �  �C(            )   
     fD  �C*         	   +   
     ��  4C,   
   ��oD�D-         0,3,v;1,0,t;2,0,l; .      	   0,0,res; /      |  vec2 z = vec2(cos(t) * 0.1, sin(t) * 0.1);
int br = 0;
for (int i = 0; i < int(l); ++i) {
	++br;
	z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + v;
	// z = vec2(pow(z.x, 4.0) - 6.0 * pow(z.x * z.y, 2.0) + pow(z.y, 4.0),
	// 4.0 * (z.x * z.x * z.x * z.y - z.y * z.y * z.y * z.x)) + v;
	if (sqrt(pow(z.x, 3.0) + pow(z.y, 3.0)) > 2.0) {
		break;
	}
};
res = float(br) / l * 2.0; 0         
   1   
     ��  �B2            3   
     ��  �C4       0                                     
                                                             
                     
                                                      RSRC