% CFDATES 確定利付債のキャッシュフロー日付
%
% この関数は、NUMBONDS の確定利付債券について、キャッシュフロー支払いの
% 日付行列を出力します。この関数は、最初の、または最後のクーポン支払
% までの期間の長短関わらず債券の全てのキャッシュフロー日付を出力します。
%
%   CFlowDates = cfdates(Settle, Maturity)
%
%   CFlowDates = cfdates(Settle, Maturity, Period, Basis, 
%                        EndMonthRule, IssueDate, FirstCouponDate, 
%                        LastCouponDate)
% 入力: 
%     Settle - 決済日
%     Maturity - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン支払回数; デフォルトは 2 (半年払い).
%     Basis - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 債券の発行日
%     FirstCouponDate - 最初のクーポン支払日
%     LastCouponDate - 最終クーポン支払日 
%
% 出力:
%     シリアル日付形式で表示された実際のキャッシュフロー支払い日からなる行列です。
%     CFlowDates 行列の行の数は NUMBONDS で、列の数は債券ポートフォリオを保有する
%     ことにより要求されるキャッシュフロー支払い日数の最大値によって決定されます。
%     キャッシュフロー支払日の数が、CFlowDates 行列の行数によって示される最大値より
%     少ない債券については、NaN 値によって桁揃えが行われます。
%
% 注意:
%     必須の引数は全て、NUMBONDS行1列、または 1行NUMBONDS列 のベクトル、または
%     スカラ引数でなければなりません。オプションとなる全ての引数は、NUMBONDS行1列、
%     または1行NUMBONDS列のベクトル、スカラ、または空行列でなければなりません。
%     値の指定のない入力には NaN を入力ベクトルとして設定してください。日付は、
%     シリアル日付番号、または日付文字列です。
%
%     それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%     'help ftb' + 引数名 (たとえば、Settle (決済日) に関するヘルプは、
%     "help ftbSettle") とタイプして得られます。
%
% 参考 CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%      CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.

% Copyright 1995-2006 The MathWorks, Inc.
