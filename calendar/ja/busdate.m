%BUSDATE  ���܂��͑O�̉c�Ɠ�
%
%   BD = busdate(D)
%   BD = busdate(D, DIREC, HOL, WEEKEND)
%
%   �I�v�V�����̓���: DIREC, HOL, WEEKEND
%
%   ����:
%         D - �V���A���ԍ����t�܂��͓��t������Ƃ��ĎQ�Ƃ���c�Ɠ��̃X�J���A
%             �x�N�g���A�܂��́A�s��B
%
%   �I�v�V�����̓���:
%     DIREC - �T�������̃X�J���A�x�N�g���A�܂��́A�s��:
%             �� (DIREC = 1, �f�t�H���g) �̉c�Ɠ����A�O (DIREC = -1) �̉c�Ɠ�
%
%       HOL - �V���A���ԍ����t�܂��͓��t������Ƃ��Ă̋x�Ɠ��̃X�J���A
%             �܂��́A�x�N�g���BHOL �̎w�肪�Ȃ��ꍇ�́A���[�`�� HOLIDAYS ��
%             ���肳��܂��B�����_�ł́ANYSE �x���̂� HOLIDAYS �ŃT�|�[�g
%             ����Ă��܂��B
%
%   WEEKEND - 0 �� 1 ���܂ޒ��� 7 �̃x�N�g���B�l 1 �͏T���������܂��B
%             ���̃x�N�g���̍ŏ��̗v�f�́ASunday �ɑΉ����܂��B���Ƃ��΁A
%             Saturday �� Sunday ���T���Ƃ���ƁAWEEKEND = [1 0 0 0 0 0 1] 
%             �ƂȂ�܂��B
%
%   �o��:
%        BD - HOL �Ɉˑ����鎟�܂��͑O�̉c�Ɠ��̃X�J���A�x�N�g���A�܂��́A�s��B
%
%   ��:
%      bd = busdate('3-jul-1997', 1)
%      bd =
%          729578 % 07-Jul-1997
%
%  �Q�l HOLIDAYS, ISBUSDAY.


%  Copyright 1995-2008 The MathWorks, Inc.
