FROM grafana/grafana-oss:latest
USER root

RUN grafana-cli plugins install volkovlabs-form-panel
RUN grafana-cli plugins install volkovlabs-variable-panel
RUN grafana-cli plugins install volkovlabs-echarts-panel
RUN grafana cli plugins install marcusolsson-static-datasource
RUN grafana cli plugins install marcusolsson-dynamictext-panel
RUN grafana-cli plugins install volkovlabs-table-panel

RUN sed -i 's|<title>\[\[.AppTitle\]\]</title>|<title>NuEyne Dashboard</title>|g' /usr/share/grafana/public/views/index.html


RUN find /usr/share/grafana/public/build/ -name "*.js" -exec sed -i 's|Welcome to Grafana|Welcome to NuEyne|g' {} +


RUN find /usr/share/grafana/public/build/ -name "*.js" -exec sed -i 's|"Grafana"|"NuEyne Dashboard"|g' {} +

# ── 로고 교체 ──────────────────────────────────────
COPY --chown=grafana:root ./grafana_icon.svg /usr/share/grafana/public/img/grafana_icon.svg
COPY --chown=grafana:root ./grafana_icon.svg /usr/share/grafana/public/img/grafana_com_auth_icon.svg
COPY --chown=grafana:root ./grafana_icon.svg /usr/share/grafana/public/img/grafana_net_logo.svg
COPY --chown=grafana:root ./fav32.png        /usr/share/grafana/public/img/fav32.png
COPY --chown=grafana:root ./fav32.png        /usr/share/grafana/public/img/apple-touch-icon.png

# ── build 폴더 해시파일 교체 ───────────────────────
RUN find /usr/share/grafana/public/build -name "grafana_icon*.svg" \
    -exec cp /usr/share/grafana/public/img/grafana_icon.svg {} \;

RUN find /usr/share/grafana/public/build -name "fav32.png" \
    -exec cp /usr/share/grafana/public/img/fav32.png {} \;

RUN BUNDLE=$(grep -rl "grafana\.com/oss" /usr/share/grafana/public/build/ | head -1) && \
    echo "Target bundle: $BUNDLE" && \
    sed -i 's|https://grafana\.com/oss|https://github.com/nueyne/nueyne-custom-dashboard|g' "$BUNDLE"

USER grafana
