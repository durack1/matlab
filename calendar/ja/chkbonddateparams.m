% CHKBONDDATEPARAMS 債券パラメータのテストとデフォルト値の設定
%
% CHKBONDDATEPARAMS は、全ての入力間でサイズに一貫性があるか、Bond パラ
% メータとデフォルト設定のチェックを行い、出力全てが同一のサイズとなる
% ようにスカラ拡張を実行します。日付パラメータについては、 [] が組み
% 込まれている時はデフォルトに設定し、引数が適切かのチェックを行い、
% シリアル日付番号への変換を実行します。
%
%      [Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,
%       FirstCouponDate, LastCouponDate, StartDate, P1, P2, ...]=
%       chkbonddateparams(Settle, Maturity, Period, Basis,
%       EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,
%       StartDate, P1in, P2in, ... )
%
% 入力は、スカラ、空、または適合するベクトル (NaN を含むことも可) でなければ
% なりません。出力は、空、または適合する列ベクトルとなります。
%
% 日付引数とデフォルト値 
%      Settle            none
%      Maturity          none
%      Period            2
%      Basis             0
%      EndMonthRule      1
%      IssueDate         []
%      FirstCouponDate   []
%      LastCouponDate    []
%      StartDate         []
%
%
% 参考 SCALEUPVARG.


%   Copyright 1995-2006 The MathWorks, Inc.
