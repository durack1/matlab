% LBUSDATE ���̍Ō�̉c�Ɠ�
%
%   D = lbusdate(Y, M)
%   D = lbusdate(Y, M, HOL, WEEKEND)
%
% �I�v�V�����̓���: HOL, WEEKEND
%
% ����:
%     Y - �N (��: 2002)
%  
%     M - �� (��: 12 <12��>)
%
% �I�v�V�����̓���:
%    HOL - �x�Ɠ��������x�N�g���ł��BHOL �̎w�肪�Ȃ��ꍇ�A�x�Ɠ��̃f�[�^��
%          ���[�`���ɂ���� HOLIDAYS �ɑΉ�����f�[�^���g���܂��B
%          �����_�ł́AHOLIDAYS �� NY �̋x�����T�|�[�g���܂��B
%  
%     WEEKEND - �T���� 1 �Ƃ��� 0 �� 1 ���܂ޒ��� 7 �̃x�N�g���ł��B
%               ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%               ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%               WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%               �y�j���Ɠ��j�����T���ɂȂ�܂��B
%
% �o��:
%         D - �w�肳�ꂽ���̍Ō�̉c�Ɠ�
%
% ��:
%      D = lbusdate(1997, 5)
%      D =
%            729540   % 1997�N5��30��
%
% �Q�l BUSDATE, EOMDATE, FBUSDATE, HOLIDAYS, ISBUSDAY.


% Copyright 1995-2006 The MathWorks, Inc.
