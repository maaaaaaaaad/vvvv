import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final domains = ['auth', 'owner', 'beautishop', 'category', 'treatment', 'review'];
  final projectRoot = _findProjectRoot();
  final libPath = '$projectRoot/lib';

  group('Clean Architecture Tests', () {
    group('Domain Layer Independence', () {
      for (final domain in domains) {
        test('$domain domain layer should not import data layer', () async {
          final domainPath = '$libPath/features/$domain/domain';
          final violations = await _findImportViolations(
            directoryPath: domainPath,
            forbiddenPatterns: [
              'features/$domain/data/',
              "features/$domain/data'",
            ],
          );

          expect(
            violations,
            isEmpty,
            reason:
                'Domain layer in $domain should not import from data layer.\n'
                'Violations found:\n${violations.join('\n')}',
          );
        });

        test(
          '$domain domain layer should not import presentation layer',
          () async {
            final domainPath = '$libPath/features/$domain/domain';
            final violations = await _findImportViolations(
              directoryPath: domainPath,
              forbiddenPatterns: [
                'features/$domain/presentation/',
                "features/$domain/presentation'",
              ],
            );

            expect(
              violations,
              isEmpty,
              reason:
                  'Domain layer in $domain should not import from presentation layer.\n'
                  'Violations found:\n${violations.join('\n')}',
            );
          },
        );
      }
    });

    group('Data Layer Independence', () {
      for (final domain in domains) {
        test('$domain data layer should not import presentation layer', () async {
          final dataPath = '$libPath/features/$domain/data';
          final violations = await _findImportViolations(
            directoryPath: dataPath,
            forbiddenPatterns: [
              'features/$domain/presentation/',
              "features/$domain/presentation'",
            ],
          );

          expect(
            violations,
            isEmpty,
            reason:
                'Data layer in $domain should not import from presentation layer.\n'
                'Violations found:\n${violations.join('\n')}',
          );
        });
      }
    });

    group('Feature Folder Structure', () {
      for (final domain in domains) {
        test('$domain should have domain layer', () {
          final domainPath = Directory('$libPath/features/$domain/domain');
          expect(
            domainPath.existsSync(),
            isTrue,
            reason: '$domain feature should have a domain folder',
          );
        });

        test('$domain should have data layer', () {
          final dataPath = Directory('$libPath/features/$domain/data');
          expect(
            dataPath.existsSync(),
            isTrue,
            reason: '$domain feature should have a data folder',
          );
        });

        test('$domain should have presentation layer', () {
          final presentationPath = Directory(
            '$libPath/features/$domain/presentation',
          );
          expect(
            presentationPath.existsSync(),
            isTrue,
            reason: '$domain feature should have a presentation folder',
          );
        });
      }
    });

    group('Domain Layer Structure', () {
      for (final domain in domains) {
        test('$domain domain should have entities folder', () {
          final entitiesPath = Directory(
            '$libPath/features/$domain/domain/entities',
          );
          final hasEntities =
              entitiesPath.existsSync() &&
              entitiesPath
                  .listSync()
                  .where((f) => f.path.endsWith('.dart'))
                  .isNotEmpty;

          if (entitiesPath.existsSync()) {
            expect(
              hasEntities,
              isTrue,
              reason: '$domain domain should have entities',
            );
          }
        });

        test('$domain domain should have repositories folder', () {
          final repositoriesPath = Directory(
            '$libPath/features/$domain/domain/repositories',
          );
          expect(
            repositoriesPath.existsSync(),
            isTrue,
            reason: '$domain domain should have a repositories folder',
          );
        });

        test('$domain domain should have usecases folder', () {
          final usecasesPath = Directory(
            '$libPath/features/$domain/domain/usecases',
          );
          expect(
            usecasesPath.existsSync(),
            isTrue,
            reason: '$domain domain should have a usecases folder',
          );
        });
      }
    });

    group('Data Layer Structure', () {
      for (final domain in domains) {
        test('$domain data should have datasources folder', () {
          final datasourcesPath = Directory(
            '$libPath/features/$domain/data/datasources',
          );
          expect(
            datasourcesPath.existsSync(),
            isTrue,
            reason: '$domain data should have a datasources folder',
          );
        });

        test('$domain data should have repositories folder', () {
          final repositoriesPath = Directory(
            '$libPath/features/$domain/data/repositories',
          );
          expect(
            repositoriesPath.existsSync(),
            isTrue,
            reason: '$domain data should have a repositories folder',
          );
        });
      }
    });

    group('Cross-Domain Import Rules', () {
      for (final domain in domains) {
        test(
          '$domain domain should not import other domain data layers',
          () async {
            final domainPath = '$libPath/features/$domain/domain';
            final otherDomains = domains.where((d) => d != domain).toList();

            final forbiddenPatterns = <String>[];
            for (final otherDomain in otherDomains) {
              forbiddenPatterns.add('features/$otherDomain/data/');
              forbiddenPatterns.add("features/$otherDomain/data'");
            }

            final violations = await _findImportViolations(
              directoryPath: domainPath,
              forbiddenPatterns: forbiddenPatterns,
            );

            expect(
              violations,
              isEmpty,
              reason:
                  '$domain domain layer should not import from other domain data layers.\n'
                  'Violations found:\n${violations.join('\n')}',
            );
          },
        );

        test(
          '$domain domain should not import other domain presentation layers',
          () async {
            final domainPath = '$libPath/features/$domain/domain';
            final otherDomains = domains.where((d) => d != domain).toList();

            final forbiddenPatterns = <String>[];
            for (final otherDomain in otherDomains) {
              forbiddenPatterns.add('features/$otherDomain/presentation/');
              forbiddenPatterns.add("features/$otherDomain/presentation'");
            }

            final violations = await _findImportViolations(
              directoryPath: domainPath,
              forbiddenPatterns: forbiddenPatterns,
            );

            expect(
              violations,
              isEmpty,
              reason:
                  '$domain domain layer should not import from other domain presentation layers.\n'
                  'Violations found:\n${violations.join('\n')}',
            );
          },
        );
      }
    });
  });
}

String _findProjectRoot() {
  var current = Directory.current;
  while (current.path != current.parent.path) {
    final pubspec = File('${current.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      return current.path;
    }
    current = current.parent;
  }
  return Directory.current.path;
}

Future<List<String>> _findImportViolations({
  required String directoryPath,
  required List<String> forbiddenPatterns,
}) async {
  final violations = <String>[];
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    return violations;
  }

  await for (final entity in directory.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().startsWith('import ')) {
          for (final pattern in forbiddenPatterns) {
            if (line.contains(pattern)) {
              final relativePath = entity.path.replaceFirst(
                '$directoryPath/',
                '',
              );
              violations.add('  File: $relativePath, Line ${i + 1}: $line');
            }
          }
        }
      }
    }
  }

  return violations;
}
