%DAYSADD  �w�肵����ɂ��J�n������̓��t
%
%   DAYSADD �́A�^����ꂽ�K���ɂ��AD1 ���� NUM �o�߂��������̓��t��
%   �Ԃ��܂��B�V���A���ԍ����t�܂��͓��t������Ƃ��ē��͂��܂��B
%
%   Date = daysadd(D1, NUM)
%   Date = daysadd(D1, NUM, BASIS)
%
%   �I�v�V�����̓���: BASIS
%
%   ����:
%      D1    - NDATESx1 �܂��� 1xNDATES �̃V���A���ԍ����t�A�܂��͓��t������
%      NUM   - NNUMx1 �܂��� 1xNNUM �̐����̍s��B
%
%   �I�v�V�����̓���:
%      BASIS - NBASISx1 �܂��� 1xNBASIS �̓����v�Z�����B
%
%      �L���� Basis �͈ȉ��̂Ƃ���ł��B
%            0 = actual/actual (�f�t�H���g)
%            1 = 30/360 SIA
%            2 = actual/360
%            3 = actual/365
%            4 - 30/360 PSA
%            5 - 30/360 ISDA
%            6 - 30/360 ���[���b�p
%            7 - act/365 ���{
%            8 - act/act ISMA
%            9 - act/360 ISMA
%           10 - act/365 ISMA
%           11 - 30/360 ISMA
%           12 - act/365 ISDA
%
%   �o��:
%      Date  -  Nx1 �s��̃V���A���ԍ����t
%
%   ����: 30/360 �̓����v�Z�����̐����ɂ��A�����v�Z�@�̊��m��
%         �����̂��߁A����������Ă��܂��A���m�ȓ��t�������邱�Ƃ͉\�ł�
%         �Ȃ���������܂���B���̎��ۂ�����Ƃ��͌x�����\������܂��B
%
%  ��:
%
%      startDt = datenum('5-Feb-2004');
%      num     = 26;
%      basis   = 1;
%
%      newDt   = daysadd(startDt,num,basis)
%
%      newDt   =
%               732007
%
%  �Q�l DAYSDIF


% Copyright 1995-2008 The MathWorks, Inc.
