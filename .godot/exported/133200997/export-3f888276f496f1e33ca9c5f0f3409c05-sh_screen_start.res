RSRC                    VisualShader            ��������                                            T      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    op_type 	   operator    script    type 	   function 
   condition 	   constant    size    expression    input_name    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/16/node    nodes/fragment/16/position    nodes/fragment/16/size    nodes/fragment/16/input_ports    nodes/fragment/16/output_ports    nodes/fragment/16/expression    nodes/fragment/17/node    nodes/fragment/17/position    nodes/fragment/18/node    nodes/fragment/18/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        '   local://VisualShaderNodeVectorOp_r8v1o �      &   local://VisualShaderNodeCompare_k1ep5       '   local://VisualShaderNodeVectorOp_52owd |      '   local://VisualShaderNodeVectorOp_q5v4v �      .   local://VisualShaderNodeVectorDecompose_p07qx f      ,   local://VisualShaderNodeFloatConstant_5i784 �      '   local://VisualShaderNodeVectorOp_wgkd3 �      '   local://VisualShaderNodeVectorOp_56kpj q      )   local://VisualShaderNodeExpression_fu2l4 �      $   local://VisualShaderNodeInput_1fmpg �      $   local://VisualShaderNodeInput_ifclk �      $   local://VisualShaderNodeInput_5k2gp �      -   local://VisualShaderNodeFloatParameter_s1ayj >      -   local://VisualShaderNodeFloatParameter_31beb �      ,   res://materials/screen/sh_screen_start.tres �         VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeCompare                                              )   �������?
                  VisualShaderNodeVectorOp                    
                 
     �A  A                            VisualShaderNodeVectorOp                    
                 
     �B  �B                             VisualShaderNodeVectorDecompose                    
                              VisualShaderNodeFloatConstant          ���=         VisualShaderNodeVectorOp                    
                 
     �?  �?                            VisualShaderNodeVectorOp                                                                                  VisualShaderNodeExpression       
   ":D\�D      V   x += a;
y += b;
res = sin(sqrt(abs(x * x * x)) + t) + sin(sqrt(abs(y * y * y)) + t);           VisualShaderNodeInput             time          VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeFloatParameter             a                   VisualShaderNodeFloatParameter             b                   VisualShader '                     shader_type canvas_item;
render_mode blend_mix;

uniform float a = 0;
uniform float b = 0;



void fragment() {
// Input:18
	vec2 n_out18p0 = SCREEN_UV;


// VectorOp:14
	vec2 n_in14p1 = vec2(1.00000, 1.00000);
	vec2 n_out14p0 = n_out18p0 - n_in14p1;


// Input:19
	vec2 n_out19p0 = SCREEN_PIXEL_SIZE;


// VectorOp:5
	vec2 n_in5p1 = vec2(100.00000, 100.00000);
	vec2 n_out5p0 = n_out19p0 * n_in5p1;


// VectorOp:4
	vec2 n_out4p0 = n_out14p0 / n_out5p0;


// VectorDecompose:6
	float n_out6p0 = n_out4p0.x;
	float n_out6p1 = n_out4p0.y;


// FloatParameter:20
	float n_out20p0 = a;


// FloatParameter:21
	float n_out21p0 = b;


// Input:17
	float n_out17p0 = TIME;


	float n_out16p0;
// Expression:16
	n_out16p0 = 0.0;
	{
		n_out6p0 += n_out20p0;
		n_out6p1 += n_out21p0;
		n_out16p0 = sin(sqrt(abs(n_out6p0 * n_out6p0 * n_out6p0)) + n_out17p0) + sin(sqrt(abs(n_out6p1 * n_out6p1 * n_out6p1)) + n_out17p0); 
	}


// Compare:3
	float n_in3p1 = 0.00000;
	bool n_out3p0 = n_out16p0 >= n_in3p1;


// FloatConstant:11
	float n_out11p0 = 0.100000;


// VectorOp:2
	vec3 n_out2p0 = vec3(n_out3p0 ? 1.0 : 0.0) * vec3(n_out11p0);


// VectorOp:15
	vec4 n_in15p0 = vec4(0.00000, 0.00000, 0.00000, 0.00000);
	vec4 n_out15p0 = n_in15p0 + vec4(n_out2p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out15p0.xyz);


}
                    "   
     �D  �B#             $   
    ��D  4C%            &   
   {t�D`�+C'            (   
   �(�`�C)            *   
   �U�`�?C+            ,   
   ɶ��`�C-            .   
   '�vD���C/            0   
     W�    1            2   
    ��D   B3            4   
      C  C5   
   ":D\�D6         0,0,x;1,0,y;2,0,a;3,0,b;4,0,t; 7      	   0,0,res; 8      V   x += a;
y += b;
res = sin(sqrt(abs(x * x * x)) + t) + sin(sqrt(abs(y * y * y)) + t);  9         	   :   
     ��  D;         
   <   
     ��  �B=            >   
     ��  �C?            @   
     ��  �CA            B   
     ��  %DC       <                                                                                                                                                                                                                    RSRC