FROM node:22-alpine AS build

ARG CONTROL_PANEL_TITLE="Control Panel"
ARG CONTROL_PANEL_SUBTITLE="System management"
ENV VITE_CONTROL_PANEL_TITLE=$CONTROL_PANEL_TITLE \
    VITE_CONTROL_PANEL_SUBTITLE=$CONTROL_PANEL_SUBTITLE

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . ./
RUN npm run build

FROM nginx:1.28-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
