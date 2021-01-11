%WRKDYDIF  日付間の営業日数
%
%   WRKDYDIF は、休業日数が設定されると、2 つの日付 (を含む) 間の営業日数を
%   定義します。
%
%   NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%
%   入力:
%            Date1          - 開始日を示す日付文字列、または、シリアル番号
%                             日付で構成される Nx1 または 1xN のベクトルです。
%
%            Date2          - 最終日を示す日付文字列、または、シリアル番号
%                             日付で構成される Nx1 または 1xN のベクトルです。
%
%   NumberHolidays - 2 つの日付間の休日の日数で構成される Nx1 または 
%                    1xN のベクトルです。
%
%   出力:
%       NumberDays      - Date1 及び Date2 (を含む) 間の日数を示す Nx1 
%                         または 1xN のベクトルです。
%
%   例:
%      Date1 = '9/1/1995';
%      Date2 = '9/11/1995';
%      NumberHolidays = 1;
%
%      NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%      NumberDays =
%           6
%
%   参考 DATEWRKDY.


%   Copyright 1995-2008 The MathWorks, Inc.
