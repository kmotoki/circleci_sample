#!/bin/bash
set -v

# master ブランチを分析対象から除外する。
DEFAULT_BRANCH="master"
if [ "${CIRCLE_BRANCH}" !=  "${DEFAULT_BRANCH}" ]; then

    # .java ファイルに変更がなければ、動作を終了する。
    LIST=`git diff --name-only origin/${DEFAULT_BRANCH} | grep -e '.java$'`
    if [ -z "$LIST" ]; then
        echo "No java file has changed."
        exit 0
    fi

    # checkstyle による分析を実行する。
    echo $LIST \
    | xargs java -Duser.language=ja -classpath lib/checkstyle-5.7-all.jar com.puppycrawl.tools.checkstyle.Main -f xml \
    | bundle exec checkstyle_filter-git exec "git diff --no-color origin/${DEFAULT_BRANCH}" \
    | bundle exec saddler report \
        --require saddler/reporter/github \
        --reporter Saddler::Reporter::Github::CommitReviewComment

    # Findbugs による分析を実行する。
    java -Duser.language=ja -jar $HOME/findbugs/lib/findbugs.jar -textui \
        -auxclasspath lib/ -auxclasspath WEB-INF/lib/ -sourcepath WEB-INF/src/ \
        -xml WEB-INF/classes \
    | bundle exec findbugs_translate_checkstyle_format translate \
    | bundle exec checkstyle_filter-git exec "git diff --no-color origin/${DEFAULT_BRANCH}" \
    | bundle exec saddler report \
        --require saddler/reporter/github \
        --reporter Saddler::Reporter::Github::CommitReviewComment
fi
exit 0
