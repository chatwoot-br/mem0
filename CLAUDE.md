# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Environment Setup
- Use `hatch` for environment management
- Activate environment: `hatch shell dev_py_3_12` (or 3.9, 3.10, 3.11)
- Install all dependencies: `make install_all`

### Code Quality
- Format code: `make format` (uses ruff)
- Sort imports: `make sort` (uses isort with black profile)
- Lint: `make lint` (uses ruff)
- Run all quality checks: `make all`

### Testing
- Run tests: `make test`
- Test specific Python version: `make test-py-3.12` (or 3.9, 3.10, 3.11)
- Pre-commit hooks: `pre-commit install`

### Build & Package
- Build package: `make build`
- Publish: `make publish`
- Clean build artifacts: `make clean`

## Architecture Overview

Mem0 is a memory layer for AI agents and assistants with the following core architecture:

### Main Components

1. **Memory Core** (`mem0/memory/main.py`)
   - `Memory` and `AsyncMemory` classes - primary interfaces
   - Handles multi-level memory (User, Session, Agent)
   - Integrates with vector stores, LLMs, and embeddings

2. **Vector Stores** (`mem0/vector_stores/`)
   - Supports 20+ vector databases (Qdrant, Chroma, Pinecone, Weaviate, etc.)
   - Factory pattern for store instantiation
   - Unified interface across different backends

3. **LLMs** (`mem0/llms/`)
   - Supports OpenAI, Anthropic, Google, AWS Bedrock, Azure, and more
   - Structured output support for memory extraction
   - Factory pattern for LLM instantiation

4. **Embeddings** (`mem0/embeddings/`)
   - Multiple embedding providers (OpenAI, HuggingFace, Google, etc.)
   - Configurable embedding dimensions and models

5. **Graph Memory** (`mem0/memory/graph_memory.py`)
   - Knowledge graph-based memory using Neo4j, Neptune, Kuzu
   - Relationship extraction and storage

6. **Storage** (`mem0/memory/storage.py`)
   - SQLite-based metadata storage
   - Tracks memory metadata, relationships, and telemetry

### Configuration System

- Pydantic-based configuration in `mem0/configs/`
- Separate configs for LLMs, vector stores, embeddings
- Environment-based configuration support

### Client Interface

- `MemoryClient` for API-based usage (hosted platform)
- Direct `Memory` class for self-hosted deployment
- Both sync and async implementations

### Key Patterns

- Factory pattern for component instantiation (`mem0/utils/factory.py`)
- Plugin architecture for extending vector stores and LLMs
- Telemetry and analytics collection
- Memory types: User, Session, Agent with hierarchical organization

### Testing

Tests are organized by component in `tests/` matching the `mem0/` structure. Use pytest for running tests across multiple Python versions (3.9-3.12).