RSRC                    VisualShader            ��������                                            F      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    op_type 	   operator 	   constant    size    expression    type 	   function 
   condition    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/20/size    nodes/fragment/20/input_ports    nodes/fragment/20/output_ports    nodes/fragment/20/expression    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/22/node    nodes/fragment/22/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_xippk �	      $   local://VisualShaderNodeInput_x0hbk )
      '   local://VisualShaderNodeVectorOp_t1a5d a
      '   local://VisualShaderNodeVectorOp_k77rp �
      '   local://VisualShaderNodeVectorOp_mg7v8 K      '   local://VisualShaderNodeVectorOp_rwrm0 �      $   local://VisualShaderNodeInput_qdla7 5      $   local://VisualShaderNodeInput_ae1nj y      ,   local://VisualShaderNodeFloatConstant_bxe31 �      )   local://VisualShaderNodeExpression_r74if �      &   local://VisualShaderNodeCompare_l63bu �      '   local://VisualShaderNodeVectorOp_bvbnn �         local://VisualShader_r5tvd J         VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                                  VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeVectorOp                    
                 
     �A  A                            VisualShaderNodeVectorOp                    
                 
     �?  �?                            VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeInput             time          VisualShaderNodeFloatConstant    	      ��L=         VisualShaderNodeExpression    
   
   =�D)<�C      |   float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
res = sin(sqrt(r) - a + t);          VisualShaderNodeCompare                      VisualShaderNodeVectorOp                    
                 
      �   �                   VisualShader "         B  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:3
	vec4 n_out3p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// VectorOp:22
	vec2 n_in22p1 = vec2(-0.50000, -0.50000);
	vec2 n_out22p0 = n_out2p0 + n_in22p1;


// Input:12
	vec2 n_out12p0 = SCREEN_PIXEL_SIZE;


// VectorOp:11
	vec2 n_in11p1 = vec2(1.00000, 1.00000);
	vec2 n_out11p0 = n_out12p0 * n_in11p1;


// VectorOp:10
	vec2 n_out10p0 = n_out22p0 / n_out11p0;


// Input:15
	float n_out15p0 = TIME;


	float n_out20p0;
// Expression:20
	n_out20p0 = 0.0;
	{
		float r = sqrt(n_out10p0.x * n_out10p0.x + n_out10p0.y * n_out10p0.y);
		float a = atan(n_out10p0.y / n_out10p0.x);
		if (n_out10p0.x < 0.0) {
			a += PI;
		};
		n_out20p0 = sin(sqrt(r) - a + n_out15p0);
	}


// Compare:21
	float n_in21p1 = 0.00000;
	bool n_out21p0 = n_out20p0 >= n_in21p1;


// FloatConstant:19
	float n_out19p0 = 0.050000;


// VectorOp:5
	vec3 n_out5p0 = vec3(n_out21p0 ? 1.0 : 0.0) * vec3(n_out19p0);


// VectorOp:4
	vec4 n_out4p0 = n_out3p0 + vec4(n_out5p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out4p0.xyz);


}
                       
    ��D  �B                
     C�  �B               
     ��  ��               
    ��D  �B                
    ��D  HC!            "   
     ��  4C#            $   
     ��  pC%            &   
     >�  pC'            (   
     �  �C)            *   
     fD  �C+         	   ,   
     �B  4C-   
   =�D)<�C.         0,3,v;1,0,t; /      	   0,0,res; 0      |   float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
res = sin(sqrt(r) - a + t); 1         
   2   
     RD  HC3            4   
     ��  �B5       0                                     
                                                                                         
                     
                           RSRC