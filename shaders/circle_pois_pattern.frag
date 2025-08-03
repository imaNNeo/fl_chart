#include <flutter/runtime_effect.glsl>

precision mediump float;

// INGRESSI
uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_num_circles;
uniform float gap;
uniform float vgap;
uniform float margin;

out vec4 sk_FragColor;

void main() {
    float W = u_resolution.x;
    float H = u_resolution.y;
    int N = int(u_num_circles);   // Numero colonne
    vec2 currentPos = FlutterFragCoord();

    float diameter = (W - float(N - 1) * gap - 2.0 * margin) / float(N);
    float radius = diameter / 2.0;

    int num_rows = int(floor((H - 2.0 * margin + vgap) / (diameter + vgap)));

    float used_height = float(num_rows) * diameter + float(num_rows - 1) * vgap;
    float vertical_offset = (H - used_height) / 2.0;

    bool in_circle = false;

    for (int row = 0; row < 32; row++) {
        if (row >= num_rows) break;

        float y = vertical_offset + radius + float(row) * (diameter + vgap);

        for (int col = 0; col < 32; col++) {
            if (col >= N) break;

            float x = margin + radius + float(col) * (diameter + gap);
            vec2 center = vec2(x, y);

            float d = distance(currentPos.xy, center);
            if (d < radius) {
                in_circle = true;
                break;
            }
        }
        if (in_circle) break;
    }

    if (in_circle) {
        sk_FragColor = vec4(u_color, 1.0);
    } else {
        discard;
    }
}
