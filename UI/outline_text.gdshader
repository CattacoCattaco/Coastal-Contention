shader_type canvas_item;

uniform vec4 outline_color: source_color = vec4(1, 1, 1, 1);
uniform vec4 fill_color: source_color = vec4(0, 0, 0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	
	bool is_edge = COLOR.a == 0.0
			&& (texture(TEXTURE, UV + vec2(pixel_size.x, 0)).a == 1.0
			|| texture(TEXTURE, UV + vec2(-pixel_size.x, 0)).a == 1.0
			|| texture(TEXTURE, UV + vec2(0, pixel_size.y)).a == 1.0
			|| texture(TEXTURE, UV + vec2(0, -pixel_size.y)).a == 1.0);
	
	if(is_edge) {
		COLOR = outline_color;
	}
	else if(base.a > 0.0) {
		COLOR = fill_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
