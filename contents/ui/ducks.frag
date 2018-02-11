uniform vec2 c;
uniform int iter;
uniform float esc;
uniform int pre;
uniform float col;
uniform float zoom;
uniform float ratio;
uniform vec2 pos;

varying highp vec2 qt_TexCoord0;

const float pi = 3.14159265359;

vec2 clog(vec2 a) {
    float b =  atan(a.y,a.x);
    if (b > 0.0) b -= 2.0*pi;
    return vec2(log(length(a)),b);
}

vec2 cmul(vec2 a, vec2 b) {
    return vec2(a.x*b.x -  a.y*b.y, a.x*b.y + a.y*b.x);
}

vec2 duck(vec2 z, vec2 c) {
    int i;
    float mean = 0.0;
    for(i = 0; i < iter; ++i) {
        z = clog(vec2(z.x,abs(z.y))) + c;
        if (i > pre)
            mean += length(z);

        if (dot(z,z) > esc && i > pre)
            break;
    }
    mean/=float(i-pre);

    return vec2(float(i), mean);
}

void main() {
    vec2 coord = vec2(2.0,-2.0)*qt_TexCoord0 + vec2(-1.0,1.0);
    coord.x *= ratio;
    coord = coord*zoom + pos;

    vec2 r = duck(coord, c);

    float ci = r.x + 1.0 - log2(.5*log2(r.y*col));
    gl_FragColor = vec4(0.5+0.5*cos(6.0*ci),
                        0.5+0.5*cos(6.0*ci+0.4),
                        0.5+0.5*cos(6.0*ci+0.87931), 1.0);
}

