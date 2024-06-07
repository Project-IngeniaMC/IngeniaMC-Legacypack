#version 150

#moj_import <fog.glsl>
#define PI 3.1415926538

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

vec3 wobble(float t){
    return vec3(0, t * 3, 0);
}

void main() {
    // Vanilla behaviour
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    // The in-game time
    // Ranges from 0 to 1 every second
    float timeLoop = GameTime * 1200;
    float fractedTimeLoop = fract(GameTime * 1200);
    float xPx = 1.0 / ScreenSize.x;
    float yPx = 1.0 / ScreenSize.y;

    if (Color.xyz == vec3(71/255., 92/255., 36/255.) && ( // Rainbow text
        Position.z == 0.03 || // Actionbar
        Position.z == 0.06 || // Subtitle
        Position.z == 0.12 || // Title
        Position.z == 100.03 || // Chat
        Position.z == 200.03 || // Advancement Screen
        Position.z == 400.03    // Items
        )) {
            vec3 col = 0.5 + 0.5*cos(vec3(timeLoop, timeLoop, timeLoop) + vec3(0,2,4));
            vertexColor = vec4(col,Color.w) * texelFetch(Sampler2, UV2 / 16, 0); // Color the text
    } 
    else if (Color.xyz == vec3(79/255., 92/255., 36/255.) && ( // Wobble text effect
        Position.z == 0.03 || // Actionbar
        Position.z == 0.06 || // Subtitle
        Position.z == 0.12 || // Title
        Position.z == 100.03 || // Chat
        Position.z == 200.03 || // Advancement Screen
        Position.z == 400.03    // Items
        )){
            gl_Position += vec4(0.0, yPx * 4 * (0.5 + floor(cos(9*PI*(timeLoop + Position.x)))) * 2, 0.0, 0.0);
            vertexColor = vec4(1.0, 1.0, 1.0, 1.0) * texelFetch(Sampler2, UV2 / 16, 0);
    }
    else if (Color.xyz == vec3(19/255., 23/255., 9/255.) && Position.z == 100){  // Wobble text effect (shadow)
        gl_Position += vec4(0.0, yPx * 4 * (0.5 + floor(cos(9*PI*(timeLoop + Position.x)))) * 2, 0.0, 0.0);
    }
}
