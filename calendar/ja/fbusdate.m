% FBUSDATE ���̍ŏ��̉c�Ɠ�
%
%   D = fbusdate(Y, M)
%   D = fbusdate(Y, M, HOL, WEEKEND)
%
% �I�v�V�����̓���: HOL, WEEKEND
%
% ����:
%         Y - Year (i.e. 2002)
%
%         M - Month (i.e. 12 <December>)
%
% �I�v�V�����̓���:
%     HOL - �x�Ɠ��������x�N�g���ł��BHOL �̎w�肪�Ȃ��ꍇ�A�x�Ɠ���
%           �f�[�^�̓��[�`���ɂ���� HOLIDAYS �ɑΉ�����f�[�^���g���܂��B
%           �����_�ł́AHOLIDAYS �� NY �̋x�����T�|�[�g���܂��B
%
%     WEEKEND - �T���� 1 �Ƃ��� 0 �� 1 ���܂ޒ��� 7 �̃x�N�g���ł��B
%               ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%               ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%               WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%               �y�j���Ɠ��j�����T���ɂȂ�܂��B
%
% �o��:
%         D - �w�肳�ꂽ���̍ŏ��̉c�Ɠ�
%
% ��:
%      D = fbusdate(1997, 11)
%      D =
%            729697   % 1997�N11��3��
%
% �Q�l BUSDATE, EOMDATE, HOLIDAYS, ISBUSDAY, LBUSDATE.


% Copyright 1995-2006 The MathWorks, Inc.
