RSRC                    VisualShader            ��������                                            =      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script 	   constant    size    expression    op_type 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/4/size    nodes/fragment/4/input_ports    nodes/fragment/4/output_ports    nodes/fragment/4/expression    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     	   $   local://VisualShaderNodeInput_jqboc W      ,   local://VisualShaderNodeFloatConstant_g3cyf �      )   local://VisualShaderNodeExpression_w00ro �      $   local://VisualShaderNodeInput_jorwc @	      '   local://VisualShaderNodeVectorOp_l6ah4 u	      $   local://VisualShaderNodeInput_0acya �	      '   local://VisualShaderNodeVectorOp_1upkj "
      '   local://VisualShaderNodeVectorOp_ada3x �
      )   res://shaders/overlays/m_o_circular.tres          VisualShaderNodeInput             time          VisualShaderNodeFloatConstant             VisualShaderNodeExpression    	   
   ��D���C
      =   res = sin(sqrt(abs(c.x * c.x - c.y * c.y)) - t * 1.0) > 0.0;          VisualShaderNodeInput             uv          VisualShaderNodeVectorOp                    
                 
     @A  @A                            VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                                           VisualShaderNodeVectorOp                    
                 
      �   �                   VisualShader          �  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:7
	vec4 n_out7p0 = COLOR;


// Input:2
	float n_out2p0 = TIME;


// Input:5
	vec2 n_out5p0 = UV;


// VectorOp:9
	vec2 n_in9p1 = vec2(-0.50000, -0.50000);
	vec2 n_out9p0 = n_out5p0 + n_in9p1;


// VectorOp:6
	vec2 n_in6p1 = vec2(12.00000, 12.00000);
	vec2 n_out6p0 = n_out9p0 * n_in6p1;


	bool n_out4p0;
// Expression:4
	n_out4p0 = false;
	{
		n_out4p0 = sin(sqrt(abs(n_out6p0.x * n_out6p0.x - n_out6p0.y * n_out6p0.y)) - n_out2p0 * 1.0) > 0.0;
	}


// VectorOp:8
	vec4 n_out8p0 = n_out7p0 * vec4(n_out4p0 ? 1.0 : 0.0);


// Output:0
	COLOR.rgb = vec3(n_out8p0.xyz);


}
                       
     HD  pB                
     ��  �B               
     ��  �C               
     ��  �B   
   ��D���C         0,0,t;1,3,c;        	   0,6,res; !      =   res = sin(sqrt(abs(c.x * c.x - c.y * c.y)) - t * 1.0) > 0.0; "            #   
     >�  pC$            %   
     ��  4C&            '   
   ��B��A(            )   
     D   B*            +   
     ��  4C,                                                                                      	       	                    RSRC