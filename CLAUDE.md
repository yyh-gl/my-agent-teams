# my-teams

開発ワークフロー用のClaude Code Agent Team定義リポジトリ。

## セットアップ

Agent Teamsを有効化:

```json
// settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## 利用可能なチーム

### dev-team

開発チーム。機能実装・テスト・レビューを協調して実行する5 agentチーム。

**起動例:**

```
開発チームを作成して、以下の機能を実装してください:
- Lead: タスク分解と調整
- Planner: 複雑なタスクの実装計画作成
- Implementer: コード実装
- Tester: テスト作成
- Reviewer: コードレビュー
```

**チーム構成:**

| Agent | 役割 | 書き込み権限 |
|-------|------|------------|
| Lead | オーケストレーター | なし（読み取り専用） |
| Planner | 実装計画作成（Large タスク向け） | なし（読み取り専用） |
| Implementer | プロダクションコード実装 | プロダクションコード |
| Tester | テスト作成・実行 | テストコードのみ |
| Reviewer | 品質・セキュリティレビュー | なし（読み取り専用） |

## ディレクトリ構成

```
teams/
  dev/
    CLAUDE.md          # チーム共通ルール
    agents/
      lead/
        SKILL.md       # リードagent定義
      planner/
        SKILL.md       # プランナーagent定義
      implementer/
        SKILL.md       # 実装agent定義
      tester/
        SKILL.md       # テストagent定義
      reviewer/
        SKILL.md       # レビューagent定義
```
