shader_type canvas_item;

uniform float inner_radius: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	float radial = 1.0 - length(uv);
	float inner = smoothstep(inner_radius, inner_radius + 0.1, radial);
	float outer = smoothstep(0.0, 0.1, radial);
	
	vec4 color = vec4(1.0);
	color.a = outer - inner;
	
	COLOR = color;
}