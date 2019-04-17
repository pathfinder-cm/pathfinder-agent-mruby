# Pathfinder Agent

Agent for Pathfinder container manager. Ensure appropriate containers are running on the node in which this agent reside in.

## Getting started

Install these dependencies:

- `build-essential`
- `bison`
- `clang`
- `ruby`

Then you can run `rake compile` to start the compilation process. `pathfinder-agent-mruby` binary will be available on `mruby/build/host/bin` directory.

Please ensure pathfinder server is up and running and also exports appropriate configurations before starting the agent (see configurations section).

Example:
```
export PF_SERVER_ADDR=127.0.0.1
export PF_CLUSTER=default
export PF_CLUSTER_PASSWORD=pathfinder
```

## Development Setup

Install dependencies mentioned in the getting started section.

### Running tests

Run `rake test`

## Configurations

These are possible configurations that you can set via environment variables.

```
LXD_SOCKET_PATH
PF_SERVER_SCHEME
PF_SERVER_ADDR
PF_SERVER_PORT
PF_CLUSTER
PF_CLUSTER_PASSWORD
```

## Getting Help

If you have any questions or feedback regarding pathfinder-agent-mruby:

- [File an issue](https://github.com/pathfinder-cm/pathfinder-agent-mruby/issues/new) for bugs, issues and feature suggestions.

Your feedback is always welcome.

## Limitations

- Graceful shutdown is not implemented yet.

## Further Reading

- [mruby documentation][mruby-doc]
- [pathfinder documentation][pathfinder-mono-doc]

[mruby-doc]: https://github.com/mruby/mruby/tree/master/doc
[pathfinder-mono-doc]: https://github.com/pathfinder-cm/pathfinder-mono

## License

MIT License, see [LICENSE](LICENSE).
