ARG BUN_VERSION="latest"

FROM oven/bun:${BUN_VERSION} AS builder
ARG BUN_SOURCEMAP="true"
ARG BUN_COMPILE="true"
ARG BUN_BYTECODE="true"
WORKDIR /tmp
COPY package.json bun.lock tsconfig.json ./
COPY src src
RUN bun install --frozen-lockfile --production
RUN bun build src/bootstrap.ts --outfile dist/bootstrap \
  --target bun \
  $(if [ "$BUN_SOURCEMAP" = "true" ]; then echo "--sourcemap"; fi) \
  $(if [ "$BUN_COMPILE" = "true" ]; then echo "--compile"; fi) \
  $(if [ "$BUN_BYTECODE" = "true" ]; then echo "--bytecode"; fi)
RUN bun build src/index.ts --outfile dist/index \
  --target bun \
  $(if [ "$BUN_SOURCEMAP" = "true" ]; then echo "--sourcemap"; fi)

FROM public.ecr.aws/lambda/provided:al2 AS runtime
ARG LAMBDA_RUNTIME_MODE="direct"
COPY --from=builder /usr/local/bin/bun /usr/local/bin/bun
ENV NODE_ENV=production
ENV LAMBDA_RUNTIME_MODE=${LAMBDA_RUNTIME_MODE}
COPY --from=builder /tmp/node_modules ${LAMBDA_RUNTIME_DIR}
COPY --from=builder /tmp/dist/bootstrap ${LAMBDA_RUNTIME_DIR}
COPY --from=builder /tmp/dist/index ${LAMBDA_TASK_ROOT}
CMD ["index.handler"]
