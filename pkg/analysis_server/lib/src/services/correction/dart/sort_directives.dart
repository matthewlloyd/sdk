// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/dart/abstract_producer.dart';
import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analysis_server/src/services/correction/organize_directives.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

class SortDirectives extends CorrectionProducer {
  @override
  FixKind get fixKind => DartFixKind.SORT_DIRECTIVES;

  @override
  Future<void> compute(DartChangeBuilder builder) async {
    var organizer =
        DirectiveOrganizer(resolvedResult.content, unit, resolvedResult.errors);
    // todo (pq): consider restructuring organizer to allow a passed-in change
    //  builder
    for (var edit in organizer.organize()) {
      await builder.addFileEdit(file, (DartFileEditBuilder builder) {
        builder.addSimpleReplacement(
            SourceRange(edit.offset, edit.length), edit.replacement);
      });
    }
  }

  /// Return an instance of this class. Used as a tear-off in `FixProcessor`.
  static SortDirectives newInstance() => SortDirectives();
}
