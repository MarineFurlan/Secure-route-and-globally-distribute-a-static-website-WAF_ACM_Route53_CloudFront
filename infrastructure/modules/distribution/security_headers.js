function handler(event) {
    var response = event.response;
    var headers = response.headers;

    // Lock #1: Content Security Policy
    headers['content-security-policy'] = {
        value: "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline';"
    };

    // Lock #2: Prevent clickjacking
    headers['x-frame-options'] = {
        value: 'DENY'
    };

    // Lock #3: Force HTTPS forever
    headers['strict-transport-security'] = {
        value: 'max-age=63072000; includeSubdomains; preload'
    };

    // Lock #4: No fake file types
    headers['x-content-type-options'] = {
        value: 'nosniff'
    };

    // Lock #5: Control referrer info
    headers['referrer-policy'] = {
        value: 'strict-origin-when-cross-origin'
    };

    // Lock #6: Extra XSS protection
    headers['x-xss-protection'] = {
        value: '1; mode=block'
    };

    return response;
}