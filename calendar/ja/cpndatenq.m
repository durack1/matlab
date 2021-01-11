% CPNDATENQ 確定利付債に対する次回の準クーポン日
%
% この関数は、NUMBONDS の確定利付債の次回準クーポン日を出力します。
%「次回準クーポン日」とは、第1回のクーポン日が指定されていないとして
% 算定された次回クーポン日のことです。この関数は、債券の最初、または
% 最後のクーポン支払までの期間の長短に関わらず、次回準クーポン日を出力します。
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity)
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity, Period, Basis, 
%                                     EndMonthRule, IssueDate, FirstCouponDate,
%                                     LastCouponDate)
% 入力: 
%     Settle    - 決済日
%     Maturity  - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン支払回数; デフォルトは 2 (半年払い)
%     Basis - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 債券の発行日
%     FirstCouponDate - 最初のクーポン支払日.
%     LastCouponDate - 最後のクーポン支払日
%
% 出力: 
%     NextQuasiCouponDate - 決済日以降の実際の次回準クーポン日の日付からなる
%       NUMBONDS行1列のベクトルです。決済日がクーポン日と同一の場合、この
%       関数は決済日を出力しません。代わりに、厳密に決済日以降の実際の
%       クーポン日を出力します。
%
% 注意:
%     必須の引数は、NUMBONDS行1列、または、1行NUMBONDS列のベクトル、または
%     スカラ引数でなければなりません。オプションの引数はNUMBONDS行1列、
%     または、1行NUMBONDS列 のベクトル、スカラ、または空行列でなければなりま
%     せん。値の指定のない入力には NaN を入力ベクトルとして設定してください。
%     日付は、シリアル日付番号、または日付文字列です。
%
%     それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%     'help ftb' + 引数名 (たとえば、Settle (決済日) に関するヘルプは、
%     "help ftbSettle") とタイプして参照できます。
%
% 参考 CPNDATEN, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     

% Copyright 1995-2006 The MathWorks, Inc.
