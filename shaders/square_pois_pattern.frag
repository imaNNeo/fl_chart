#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_num_squares;
uniform float gap;
uniform float vgap;
uniform float margin;

out vec4 sk_FragColor;

void main() {
    float W = u_resolution.x;
    float H = u_resolution.y;
    int N = int(u_num_squares);   // Numero colonne
    vec2 currentPos = FlutterFragCoord();

    float size = (W - float(N - 1) * gap - 2.0 * margin) / float(N);
    float half_size = size / 2.0;

    int num_rows = int(floor((H - 2.0 * margin + vgap) / (size + vgap)));
    float used_height = float(num_rows) * size + float(num_rows - 1) * vgap;
    float vertical_offset = (H - used_height) / 2.0;

    bool in_square = false;

    for (int row = 0; row < 32; row++) {
        if (row >= num_rows) break;

        float y = vertical_offset + half_size + float(row) * (size + vgap);

        for (int col = 0; col < 32; col++) {
            if (col >= N) break;

            float x = margin + half_size + float(col) * (size + gap);
            vec2 center = vec2(x, y);

            vec2 diff = abs(currentPos.xy - center);
            if (diff.x < half_size && diff.y < half_size) {
                in_square = true;
                break;
            }
        }
        if (in_square) break;
    }

    if (in_square) {
        sk_FragColor = vec4(u_color, 1.0);
    } else {
        sk_FragColor = vec4(u_color, 0.0);
    }
}
