===============
Systems Overview
===============

Seneca is a comprehensive visualization and monitoring platform for Marcus AI systems. This section provides detailed documentation of all Seneca systems, their interactions, and operational scenarios.

.. contents:: Table of Contents
   :local:
   :depth: 2

System Architecture
==================

Seneca consists of interconnected systems that work together to provide real-time visualization and monitoring of Marcus AI agents.

.. graphviz::

   digraph seneca_architecture {
       rankdir=TB;
       node [shape=box, style="rounded,filled", fontname="Arial"];
       
       subgraph cluster_external {
           label="External Systems";
           style=filled;
           fillcolor=lightgray;
           "Marcus AI Instance" [fillcolor=lightblue];
           "File System" [fillcolor=lightblue];
       }
       
       subgraph cluster_core {
           label="Core Systems";
           style=filled;
           fillcolor=lightgreen;
           "CLI System" [fillcolor=lightgreen];
           "Service Detection" [fillcolor=lightgreen];
           "Configuration" [fillcolor=lightgreen];
           "Flask Server" [fillcolor=lightgreen];
       }
       
       subgraph cluster_api {
           label="API Layer";
           style=filled;
           fillcolor=lightyellow;
           "REST APIs" [fillcolor=lightyellow];
           "WebSocket" [fillcolor=lightyellow];
           "MCP Client" [fillcolor=lightyellow];
       }
       
       subgraph cluster_processing {
           label="Processing Layer";
           style=filled;
           fillcolor=lightcyan;
           "Conversation Processor" [fillcolor=lightcyan];
           "Pipeline Manager" [fillcolor=lightcyan];
           "AI Analysis Engine" [fillcolor=lightcyan];
           "Knowledge Graph" [fillcolor=lightcyan];
       }
       
       subgraph cluster_frontend {
           label="Frontend";
           style=filled;
           fillcolor=pink;
           "Vue Application" [fillcolor=pink];
           "Canvas Components" [fillcolor=pink];
           "State Management" [fillcolor=pink];
       }
       
       // External connections
       "Marcus AI Instance" -> "Service Detection" [label="registers"];
       "Marcus AI Instance" -> "MCP Client" [label="MCP protocol"];
       "File System" -> "Service Detection" [label="service registry"];
       
       // Core system flows
       "CLI System" -> "Service Detection";
       "Service Detection" -> "Flask Server";
       "Configuration" -> "Flask Server";
       
       // API layer connections
       "Flask Server" -> "REST APIs";
       "Flask Server" -> "WebSocket";
       "MCP Client" -> "REST APIs";
       
       // Processing connections
       "REST APIs" -> "Conversation Processor";
       "REST APIs" -> "Pipeline Manager";
       "Conversation Processor" -> "AI Analysis Engine";
       "Pipeline Manager" -> "Knowledge Graph";
       
       // Frontend connections
       "WebSocket" -> "Vue Application";
       "REST APIs" -> "Vue Application";
       "Vue Application" -> "Canvas Components";
       "Vue Application" -> "State Management";
   }

System Categories
================

.. grid:: 2 2 2 3

    .. grid-item-card:: Core Systems
        :link: core-systems
        :link-type: doc
        
        Essential systems that provide the foundation for Seneca's operation.
        
        * CLI Interface
        * Marcus Service Detection
        * Configuration Management
        * Flask Web Server

    .. grid-item-card:: API Systems
        :link: api-systems
        :link-type: doc
        
        RESTful APIs and WebSocket services for data exchange.
        
        * Conversation API
        * Agent Management
        * Project Management
        * Real-time WebSocket

    .. grid-item-card:: Processing Systems
        :link: processing-systems
        :link-type: doc
        
        Data processing and analysis engines.
        
        * Conversation Processing
        * Pipeline Management
        * AI Analysis Engine
        * Knowledge Graph

    .. grid-item-card:: Frontend Systems
        :link: frontend-systems
        :link-type: doc
        
        Vue.js application and user interface components.
        
        * Vue 3 Application
        * Canvas Visualization
        * Component Library
        * State Management

    .. grid-item-card:: Infrastructure Systems
        :link: infrastructure-systems
        :link-type: doc
        
        Development, testing, and deployment infrastructure.
        
        * Docker Containers
        * Build Automation
        * Testing Framework
        * Documentation

    .. grid-item-card:: Integration Flow
        :link: integration-flow
        :link-type: doc
        
        End-to-end scenarios and system interactions.
        
        * Startup Scenarios
        * Data Flow Patterns
        * Error Handling
        * Performance Optimization

Operational Scenarios
====================

Seneca operates under various conditions and configurations. Each system adapts its behavior based on the operational context.

.. tab-set::

    .. tab-item:: Normal Operation
        
        **Marcus Instance Running + Auto-Discovery**
        
        * Service Detection finds active Marcus instance
        * MCP client establishes real-time connection
        * Full visualization capabilities enabled
        * Live agent monitoring and interaction
        
    .. tab-item:: Standalone Mode
        
        **No Marcus Instance + Historical Data**
        
        * Service Detection finds no active instances
        * System operates in log-only mode
        * Historical conversation analysis available
        * Limited to static visualizations
        
    .. tab-item:: Development Mode
        
        **Local Development + Hot Reload**
        
        * Docker development containers active
        * Vue.js hot module replacement enabled
        * API development server with debugging
        * Real-time code changes reflected

    .. tab-item:: Production Mode
        
        **Deployed + Multiple Marcus Instances**
        
        * Load balancing across Marcus instances
        * Health monitoring and failover
        * Performance optimization enabled
        * Comprehensive logging and metrics

System Interaction Patterns
===========================

Understanding how systems interact is crucial for troubleshooting and optimization.

Data Flow Patterns
-----------------

.. mermaid::

   sequenceDiagram
       participant CLI as CLI System
       participant SD as Service Detection
       participant MCP as MCP Client
       participant API as API Layer
       participant Proc as Processing
       participant UI as Frontend
       
       CLI->>SD: discover_marcus_services()
       SD->>SD: scan ~/.marcus/services/
       SD-->>CLI: active instances
       CLI->>API: start server
       API->>MCP: connect(auto_discover=True)
       MCP->>SD: find latest instance
       SD-->>MCP: service info
       MCP->>MCP: establish connection
       MCP-->>API: connection established
       API->>Proc: initialize processors
       API->>UI: start WebSocket
       
       loop Real-time Operation
           MCP->>API: conversation data
           API->>Proc: process events
           Proc->>API: analyzed data
           API->>UI: WebSocket update
           UI->>UI: update visualization
       end

Error Handling Flows
--------------------

.. mermaid::

   flowchart TD
       A[System Start] --> B{Marcus Instance Found?}
       B -->|Yes| C[Establish MCP Connection]
       B -->|No| D[Enter Log-Only Mode]
       
       C --> E{Connection Successful?}
       E -->|Yes| F[Full Operation Mode]
       E -->|No| G[Retry Connection]
       
       G --> H{Retry Limit Reached?}
       H -->|No| C
       H -->|Yes| D
       
       D --> I[Read Historical Logs]
       I --> J[Limited Visualization]
       
       F --> K[Monitor Connection Health]
       K --> L{Connection Lost?}
       L -->|Yes| M[Attempt Reconnection]
       L -->|No| K
       
       M --> N{Reconnection Successful?}
       N -->|Yes| F
       N -->|No| D

Next Steps
==========

Explore the detailed documentation for each system category:

.. toctree::
   :maxdepth: 2
   
   core-systems
   api-systems
   processing-systems
   frontend-systems
   infrastructure-systems
   integration-flow