FROM node:24-bookworm-slim AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev && npm cache clean --force


FROM node:24-bookworm-slim AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5001

RUN groupadd --system --gid 1001 nodejs \
    && useradd --system --uid 1001 --gid nodejs appuser

COPY --from=dependencies --chown=appuser:nodejs /app/node_modules ./node_modules
COPY --chown=appuser:nodejs . .

USER appuser

EXPOSE 5001

CMD ["node", "src/server.js"]
