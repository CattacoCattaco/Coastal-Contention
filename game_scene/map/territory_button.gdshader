shader_type canvas_item;

uniform float alpha = 0.0;
uniform vec4 outline_color: source_color = vec4(1, 0, 0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	if(base.a > 0.0) {
		vec2 pixel_size = TEXTURE_PIXEL_SIZE;

		bool is_edge = texture(TEXTURE, UV + vec2(pixel_size.x, 0)).a == 0.0
				|| texture(TEXTURE, UV + vec2(-pixel_size.x, 0)).a == 0.0
				|| texture(TEXTURE, UV + vec2(0, pixel_size.y)).a == 0.0
				|| texture(TEXTURE, UV + vec2(0, -pixel_size.y)).a == 0.0
				|| UV.x < pixel_size.x || UV.x > 1.0 - pixel_size.x
				|| UV.y < pixel_size.y || UV.y > 1.0 - pixel_size.y;

		if(is_edge) {
			COLOR = outline_color;
		}
		else {
			COLOR = base;
			COLOR.a = alpha;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
