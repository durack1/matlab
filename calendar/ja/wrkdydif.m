%WRKDYDIF  ���t�Ԃ̉c�Ɠ���
%
%   WRKDYDIF �́A�x�Ɠ������ݒ肳���ƁA2 �̓��t (���܂�) �Ԃ̉c�Ɠ�����
%   ��`���܂��B
%
%   NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%
%   ����:
%            Date1          - �J�n�����������t������A�܂��́A�V���A���ԍ�
%                             ���t�ō\������� Nx1 �܂��� 1xN �̃x�N�g���ł��B
%
%            Date2          - �ŏI�����������t������A�܂��́A�V���A���ԍ�
%                             ���t�ō\������� Nx1 �܂��� 1xN �̃x�N�g���ł��B
%
%   NumberHolidays - 2 �̓��t�Ԃ̋x���̓����ō\������� Nx1 �܂��� 
%                    1xN �̃x�N�g���ł��B
%
%   �o��:
%       NumberDays      - Date1 �y�� Date2 (���܂�) �Ԃ̓��������� Nx1 
%                         �܂��� 1xN �̃x�N�g���ł��B
%
%   ��:
%      Date1 = '9/1/1995';
%      Date2 = '9/11/1995';
%      NumberHolidays = 1;
%
%      NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%      NumberDays =
%           6
%
%   �Q�l DATEWRKDY.


%   Copyright 1995-2008 The MathWorks, Inc.
