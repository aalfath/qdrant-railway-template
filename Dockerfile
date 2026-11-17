# Qdrant for Railway: the official image, pinned by version and digest.
# To update: bump the tag and digest below, add a CHANGELOG.md entry, merge to main.
FROM qdrant/qdrant:v1.20.2@sha256:d277592721d2e3b73f9b797b53cf05e6a5bb2134f6d13fdbda4ca51782afbcac

# Fixed settings for Railway. Every value can still be overridden with a service variable.
#  - storage and snapshots live on the volume mounted at /qdrant/data
#  - listen on IPv4 and IPv6, so Railway's private network reaches the gRPC port too
ENV QDRANT__STORAGE__STORAGE_PATH=/qdrant/data/storage \
    QDRANT__STORAGE__SNAPSHOTS_PATH=/qdrant/data/snapshots \
    QDRANT__SERVICE__HOST=:: \
    QDRANT__SERVICE__GRPC_PORT=6334 \
    QDRANT_INIT_FILE_PATH=/qdrant/data/.qdrant-initialized

COPY --chmod=755 railway-start.sh /qdrant/railway-start.sh

EXPOSE 6333 6334
CMD ["/qdrant/railway-start.sh"]
