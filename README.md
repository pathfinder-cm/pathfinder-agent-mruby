# Pathfinder Agent

Agent for Pathfinder container manager. Ensure appropriate containers are running on the node in which this agent reside in.

## Getting started

Install these dependencies:

- `build-essential`
- `bison`
- `clang`
- `ruby`

Then you can run `rake compile` to start the compilation process. `pathfinder-agent-mruby` binary will be available on `mruby/build/host/bin` directory.

Ensure pathfinder server is up and running before starting the agent.

## Development Setup

Install dependencies mentioned in the getting started section.

### Running tests

Run `rake test`

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
