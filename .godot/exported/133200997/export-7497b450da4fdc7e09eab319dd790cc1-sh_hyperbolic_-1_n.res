RSRC                    VisualShader            ��������                                            T      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    op_type 	   operator    type 	   function 
   condition 	   constant    size    expression    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/16/node    nodes/fragment/16/position    nodes/fragment/17/node    nodes/fragment/17/position    nodes/fragment/18/node    nodes/fragment/18/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/20/size    nodes/fragment/20/input_ports    nodes/fragment/20/output_ports    nodes/fragment/20/expression    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/22/node    nodes/fragment/22/position    nodes/fragment/23/node    nodes/fragment/23/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_xippk �      $   local://VisualShaderNodeInput_x0hbk 0      '   local://VisualShaderNodeVectorOp_t1a5d h      '   local://VisualShaderNodeVectorOp_k77rp �      &   local://VisualShaderNodeCompare_c06jy R      '   local://VisualShaderNodeVectorOp_mg7v8 �      '   local://VisualShaderNodeVectorOp_rwrm0 ;      $   local://VisualShaderNodeInput_qdla7 �      .   local://VisualShaderNodeVectorDecompose_t1e6b �      '   local://VisualShaderNodeVectorOp_23b83 P      $   local://VisualShaderNodeInput_ae1nj �      ,   local://VisualShaderNodeVectorCompose_2mkfv �      (   local://VisualShaderNodeFloatFunc_m2qbx *      (   local://VisualShaderNodeFloatFunc_3l5jq `      ,   local://VisualShaderNodeFloatConstant_bxe31 �      )   local://VisualShaderNodeExpression_d6tvh �      '   local://VisualShaderNodeVectorOp_oa2bg N      '   local://VisualShaderNodeVectorOp_umlfr �      '   local://VisualShaderNodeVectorOp_qso7f 8         local://VisualShader_n4y88 �         VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                                  VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeCompare                                              )   �������?
                  VisualShaderNodeVectorOp                    
                 
     �A  A                            VisualShaderNodeVectorOp                    
                 
     �B  �B                            VisualShaderNodeInput             screen_pixel_size           VisualShaderNodeVectorDecompose                    
                              VisualShaderNodeVectorOp                    
                 
                              VisualShaderNodeInput             time          VisualShaderNodeVectorCompose                       VisualShaderNodeFloatFunc    
                  VisualShaderNodeFloatFunc    
                  VisualShaderNodeFloatConstant          ���=         VisualShaderNodeExpression       
   ��4Db��C      7   res = cos(1.0 / abs(1.0 / (x) - 1.0 / (y)) + t * 0.2);          VisualShaderNodeVectorOp                    
                 
     �?  @@                            VisualShaderNodeVectorOp                    
                 
   ��L=��L=                            VisualShaderNodeVectorOp                    
                 
      �   �                   VisualShader 0         �  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:3
	vec4 n_out3p0 = COLOR;


// Input:2
	vec2 n_out2p0 = SCREEN_UV;


// VectorOp:23
	vec2 n_in23p1 = vec2(-0.50000, -0.50000);
	vec2 n_out23p0 = n_out2p0 + n_in23p1;


// Input:12
	vec2 n_out12p0 = SCREEN_PIXEL_SIZE;


// VectorOp:11
	vec2 n_in11p1 = vec2(64.00000, 64.00000);
	vec2 n_out11p0 = n_out12p0 * n_in11p1;


// VectorOp:10
	vec2 n_out10p0 = n_out23p0 / n_out11p0;


// Input:15
	float n_out15p0 = TIME;


// FloatFunc:17
	float n_out17p0 = cos(n_out15p0);


// FloatFunc:18
	float n_out18p0 = cos(n_out15p0);


// VectorCompose:16
	vec2 n_out16p0 = vec2(n_out17p0, n_out18p0);


// VectorOp:21
	vec2 n_in21p1 = vec2(1.00000, 3.00000);
	vec2 n_out21p0 = pow(n_out16p0, n_in21p1);


// VectorOp:22
	vec2 n_in22p1 = vec2(0.05000, 0.05000);
	vec2 n_out22p0 = n_out21p0 * n_in22p1;


// VectorOp:14
	vec2 n_out14p0 = n_out10p0 + n_out22p0;


// VectorDecompose:13
	float n_out13p0 = n_out14p0.x;
	float n_out13p1 = n_out14p0.y;


	float n_out20p0;
// Expression:20
	n_out20p0 = 0.0;
	{
		n_out20p0 = cos(1.0 / abs(1.0 / (n_out13p0) - 1.0 / (n_out13p1)) + n_out15p0 * 0.2);
	}


// Compare:8
	float n_in8p1 = 0.00000;
	bool n_out8p0 = n_out20p0 >= n_in8p1;


// FloatConstant:19
	float n_out19p0 = 0.100000;


// VectorOp:5
	vec3 n_out5p0 = vec3(n_out8p0 ? 1.0 : 0.0) * vec3(n_out19p0);


// VectorOp:4
	vec4 n_out4p0 = n_out3p0 + vec4(n_out5p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out4p0.xyz);


}
                       
     �D  �B                
     >�  C               
     ��                   
     �D  �B                
    ��D  HC!            "   
     �D  HC#            $   
     ��  4C%            &   
     ��  pC'            (   
     >�  pC)            *   
     �C  4C+         	   ,   
      C  C-         
   .   
     >�  �C/            0   
     ��  �C1            2   
     ��  �C3            4   
     ��  �C5            6   
    ��D  �C7            8   
     D  4C9   
   ��4Db��C:         0,0,x;1,0,y;2,0,t; ;      	   0,0,res; <      7   res = cos(1.0 / abs(1.0 / (x) - 1.0 / (y)) + t * 0.2); =            >   
     �  �C?            @   
         �CA            B   
     ��  �BC       X                                                   
                                  
                                                                                                                                                                                         
                                        RSRC