FROM docker.io/ollama/ollama:latest

# Proxy build args - use IP to avoid DNS issues inside containers
ARG APT_PROXY
ENV http_proxy=${APT_PROXY}
ENV https_proxy=${APT_PROXY}
ENV HTTP_PROXY=${APT_PROXY}
ENV HTTPS_PROXY=${APT_PROXY}

ENV OLLAMA_HOST=http://127.0.0.1:11434

# Bake the model into the image at build time.
RUN /bin/ollama serve & \
    SERVER_PID=$! && \
    echo "Waiting for ollama server..." && \
    for i in $(seq 1 30); do \
        if OLLAMA_HOST=http://127.0.0.1:11434 /bin/ollama list > /dev/null 2>&1; then \
            echo "Server ready (attempt $i)"; break; \
        fi; \
        sleep 2; \
    done && \
    echo "Pulling qwen2.5:3b..." && \
    OLLAMA_HOST=http://127.0.0.1:11434 /bin/ollama pull qwen2.5:3b && \
    echo "Pull complete" && \
    kill $SERVER_PID && \
    wait $SERVER_PID 2>/dev/null; \
    exit 0

# Clear proxy env vars from runtime image
ENV http_proxy=""
ENV https_proxy=""
ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""

EXPOSE 11434
ENTRYPOINT ["/bin/ollama"]
CMD ["serve"]
